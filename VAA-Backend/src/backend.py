from flask import Flask, request, send_from_directory
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.exc import IntegrityError
from flask_jwt_extended import create_access_token
from flask_jwt_extended import get_jwt_identity
from flask_jwt_extended import jwt_required
from flask_jwt_extended import JWTManager
from datetime import timedelta
from bcrypt import hashpw, gensalt, checkpw
import os

app  = Flask(__name__)

# impostazioni Server
app.config['SECRET_KEY'] = 'secret-key'

# impostazioni JSON Web Token
app.config["JWT_SECRET_KEY"] = "super-secret"
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = timedelta(hours=1)
jwt = JWTManager(app)

# info DB
DB_USER     = 'matteo'
DB_PASSWORD = 'matteo'
DB_SERVER   = 'localhost'
DB_NAME     = 'survey'

# impostazioni MySQL
DATABASE_URI=f"mysql+mysqlconnector://{DB_USER}:{DB_PASSWORD}@{DB_SERVER}/{DB_NAME}"
app.config['SQLALCHEMY_DATABASE_URI'] = DATABASE_URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# ------- [DEFINIZIONE TABELLE] ------- #

class Users(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key = True)
    user = db.Column(db.String(32), unique = True)
    salt = db.Column(db.String(32))
    password = db.Column(db.String(255))
    last = db.Column(db.Integer)

    def __init__(self, user, salt, password):
        self.user = user
        self.salt = salt
        self.password = password
        self.last = 1

    def __repr__(self):
        return f"[ {self.user} | {self.salt} | {self.password} | {self.last} ]"

class Questions(db.Model):
    __tablename__ = 'questions'
    id = db.Column(db.Integer, primary_key = True)
    text = db.Column(db.String)

    def __init__(self, text):
        self.text = text

    def __repr__(self):
        return f"[ {self.id} | {self.text} ]"

class Answers(db.Model):
    __tablename__ = 'answers'
    user = db.Column(db.Integer, primary_key = True)
    question = db.Column(db.Integer, primary_key = True)
    answer = db.Column(db.Integer)
    created_at = db.Column(db.DateTime, server_default=db.func.now())
    updated_at = db.Column(db.DateTime, server_default=db.func.now(), server_onupdate=db.func.now())

    def __init__(self, user, question, answer):
        self.user = user
        self.question = question
        self.answer = answer

    def __repr__(self):
        return f"[ {self.user} | {self.question} | {self.answer} ]"

# ---------------------------------- #

@app.route('/')
def root():
    root_dir = os.path.dirname(os.getcwd())
    return send_from_directory(os.path.join(root_dir, 'static'), 'index.html')

@app.route('/<path:filename>')
def serve_static(filename):
    root_dir = os.path.dirname(os.getcwd())
    return send_from_directory(os.path.join(root_dir, 'static'), filename)

@app.route('/users/register', methods=['POST'])
def add_users():
    try:
        # hashing password
        salt = gensalt()
        passwd = hashpw(request.json['password'].encode('utf-8'), salt)

        # aggiunta al DB
        user = Users(user=request.json['user'], salt=salt, password=passwd)
        db.session.add(user)
        db.session.commit()
    except IntegrityError:
        db.session.rollback()
        return { 'message' : "utente gia inserito" }, 400

    # ritorno il token per l'accesso alle risorse
    access_token = create_access_token(identity=user.id)
    return { 'token' : access_token }, 201

@app.route('/users/login', methods=['POST'])
def log_in_user():
    user = Users.query.filter_by(user=request.json['user']).first()

    # controllo se l'utente esiste
    if not user:
        return { "message" : "Utente non trovato" }, 404

    # hashing password
    salt = user.salt.encode('utf-8')
    passwd = hashpw(request.json['password'].encode('utf-8'), salt)
    original = user.password.encode('utf-8')

    # check della password
    if passwd != original:
        return { "message" : "Password errata" }, 400
    
    # ritorno il token per l'accesso alle risorse
    access_token = create_access_token(identity=user.id)
    return { 'token' : access_token, "last" : user.last }

@app.route('/users/last', methods=['GET'])
@jwt_required()
def show_users_last():
    current_id = get_jwt_identity()
    user = Users.query.filter_by(id=current_id).first()
    
    if not user:
        return { "message" : "Utente non trovato" }, 404

    # ritorno il valore della prossima domanda alla quale l'utente deve rispondere
    return {
        "last" : user.last 
    }

@app.route('/users/last', methods=['PUT'])
@jwt_required()
def update_users_last():
    current_id = get_jwt_identity()
    user = Users.query.filter_by(id=current_id).first()

    if not user:
        db.session.rollback()
        return { "message" : "Utente non trovato" }, 404

    # aggiorno il valore della prossima domanda alla quale l'utente deve rispondere
    if user.last != request.json['last']:
        user.last = request.json['last']
    
    db.session.commit()

    return {
        "last" : user.last 
    }

@app.route('/questions/<id>', methods=['GET'])
def show_question(id):
    question = Questions.query.filter_by(id=id).first()

    if not question:
        return { "message" : "Risposta non trovata" }, 404

    return { 
        "id" : question.id, 
        "text" : question.text
    }

@app.route('/questions/count', methods=['GET'])
def questions_count():
    count = Questions.query.count()
    return { "count" : count }

@app.route('/answers', methods=['GET'])
@jwt_required()
def show_user_answers():
    current_id = get_jwt_identity()
    answers = Answers.query.filter_by(user=current_id).all()
    answers = [ { "question" : answer.question, "answer" : answer.answer } for answer in answers ]
    return { "answer" : answers }

@app.route('/answers/<quest>', methods=['GET'])
@jwt_required()
def show_specific_answers(quest):
    current_id = get_jwt_identity()
    answer = Answers.query.filter_by(user=current_id).filter_by(question=quest).first()

    if answer is None:
        return { "answer" : 0 }

    return { "answer" : answer.answer }

@app.route('/answers', methods=['POST'])
@jwt_required()
def add_answer():
    current_id = get_jwt_identity()
    try:
        answer = Answers(user=current_id, question=request.json['question'], answer=request.json['answer'])
        db.session.add(answer)
        db.session.commit()
    except IntegrityError:
        db.session.rollback()
        return { 'message' : "Risposta già inserita" }, 400

    return { 
        "user" : answer.user, 
        "question" : answer.question, 
        "answer" : answer.answer 
    }, 201

@app.route('/answers', methods=['PUT'])
@jwt_required()
def update_answer(): 
    current_id = get_jwt_identity()
    answer = Answers.query.filter_by(user=current_id).filter_by(question=request.json['question']).first()
    
    # se la risposta non esiste la creo
    if answer is None:
        try:
            answer = Answers(user=current_id, question=request.json['question'], answer=request.json['answer'])
            db.session.add(answer)
            db.session.commit()
        except IntegrityError:
            db.session.rollback()
            return { 'message' : "Inserimento risposta fallito, riprovare" }, 400
        
        return { 
            "user" : answer.user, 
            "question" : answer.question, 
            "answer" : answer.answer 
        }, 201

    # se la risposta esiste la modifico
    answer.answer = request.json['answer']
    db.session.commit()

    return { 
        "user" : answer.user, 
        "question" : answer.question, 
        "answer" : answer.answer 
    }, 201

@app.route('/result', methods=['GET'])
@jwt_required()
def show_result():
    current_id = get_jwt_identity()
    answers = [ { 'user' : ans.user, 'question' : ans.question, 'answer' : ans.answer } for ans in Answers.query.filter_by(user=current_id).all() ]

    # qui verrà richiamato l'algoritmo per l'allineamento (per test ritorno le risposte precedenti e delle coordinate di prova)
    return {
        'answers' : answers,
        'x' : 0.6,
        'y' : 0.3
    }