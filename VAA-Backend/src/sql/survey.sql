CREATE DATABASE  IF NOT EXISTS `survey` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `survey`;
-- MySQL dump 10.13  Distrib 8.0.25, for Win64 (x86_64)
--
-- Host: localhost    Database: survey
-- ------------------------------------------------------
-- Server version	8.0.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `answers`
--

DROP TABLE IF EXISTS `answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `answers` (
  `user` int NOT NULL,
  `question` int NOT NULL,
  `answer` int NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user`,`question`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answers`
--

LOCK TABLES `answers` WRITE;
/*!40000 ALTER TABLE `answers` DISABLE KEYS */;
/*!40000 ALTER TABLE `answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` (`id`, `text`) VALUES (1,'Nel complesso, essere membri dell\'UE è uno svantaggio'),(2,'L\'Italia dovrebbe uscire dall\'Euro'),(3,'Il diritto dei cittadini dell\'Unione Europea di lavorare in Italia dovrebbe essere limitato'),(4,'L\'Unione Europea dovrebbe avere una politica estera comune, anche a costo di limitare l\'autonomia dell\'Italia'),(5,'Ogni singolo paese dell\'Unione Europea dovrebbe poter bloccare le riforme dei trattati'),(6,'L\'ingresso di altri paesi nell\'Unione Europea è una cosa positiva'),(7,'L\'Unione Europea dovrebbe redistribuire le risorse dalle regioni più ricche dell\'Unione a quelle più povere'),(8,'I trattati europei dovrebbero essere sempre ratificati tramite consultazioni popolari'),(9,'Il Presidente della Commissione Europea dovrebbe essere eletto direttamente dai cittadini'),(10,'Dovrebbe esistere un esercito comune europeo'),(11,'Le multinazionali come Google e Youtube dovrebbero pagare i diritti d\'autore e le tasse secondo le regole di ciascun paese europeo'),(12,'L\'integrazione economica europea si è spinta troppo oltre: gli Stati membri dovrebbero riguadagnare maggiore autonomia'),(13,'L\'Unione Europea dovrebbe riformare la propria politica dell\'immigrazione: l\'Italia dovrebbe ricevere più supporto dagli altri Stati Membri'),(14,'L\'Italia dovrebbe intensificare le sue relazioni economiche con la Cina'),(15,'La Commissione Europea dovrebbe avere un atteggiamento più conciliante con le richieste dell\'Italia'),(16,'Le coppie omosessuali dovrebbero avere gli stessi diritti garantiti alle coppie eterosessuali'),(17,'L\'uso ricreativo della cannabis dovrebbe essere legale'),(18,'Restrizioni della libertà personale e della privacy sono accettabili per combattere il crimine'),(19,'L\'Islam è una minaccia per i valori dell\'Italia'),(20,'Alle donne deve essere garantita autonomia di scelta sull\'aborto'),(21,'Per mantenere l\'ordine pubblico, il governo dovrebbe poter limitare le manifestazioni pubbliche'),(22,'Gli immigrati devono adottare i valori italiani e la cultura del nostro paese'),(23,'I reati meno gravi dovrebbero essere puniti con pene alternative'),(24,'Ogni forma di auto-difesa all\'interno della proprietà privata dovrebbe essere legittima'),(25,'Le attività della magistratura devono essere indipendenti dalle pressioni della politica'),(26,'I bambini, nati in Italia da cittadini stranieri, dovrebbe ricevere la cittadinanza italiana automaticamente'),(27,'Solo le famiglie tradizionali legalmente riconosciute (coppie eterosessuali sposate) dovrebbero essere aiutate economicamente dallo Stato'),(28,'Le armi dovrebbero poter essere detenute in casa anche senza licenza'),(29,'La ricchezza dovrebbe essere redistribuita dai cittadini più abbienti ai cittadini più poveri'),(30,'Lo Stato dovrebbe intervenire il meno possibile in questioni economiche'),(31,'Le Regioni più ricche devono contribuire di più al bilancio nazionale rispetto alle Regioni più povere'),(32,'Le imprese dovrebbe poter licenziare i dipendenti più facilmente'),(33,'La Sanità dovrebbe essere più aperta agli operatori privati'),(34,'Proteggere l\'ambiente è più importante della crescita economica'),(35,'Tagliare la spesa pubblica è un buon modo per risolvere la crisi economica'),(36,'L\'uso dell\'energia nucleare dovrebbe essere promosso per ridurre la dipendenza energetica dall\'estero'),(37,'L\'Unione Europea dovrebbe consentire un regime di aiuti pubblici alle imprese pubbliche e private'),(38,'Il numero dei dipendenti pubblici dovrebbe essere ridotto'),(39,'Il sostegno al reddito alle fasce più povere della popolazione è positivo per l\'economia italiana'),(40,'La priorità del governo dovrebbe essere la riduzione del debito pubblico, anche a costo di tagli ai servizi pubblici'),(41,'L\'introduzione di una aliquota unica sui redditi (flat tax) sarebbe di beneficio all\'economia italiana');
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` varchar(32) NOT NULL,
  `salt` varchar(32) NOT NULL,
  `password` varchar(255) NOT NULL,
  `last` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_UNIQUE` (`user`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'survey'
--

--
-- Dumping routines for database 'survey'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-07-20 12:32:48
