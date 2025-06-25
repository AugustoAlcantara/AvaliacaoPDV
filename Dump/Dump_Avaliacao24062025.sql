-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: avaliacaopdv
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `tbcliente`
--

DROP TABLE IF EXISTS `tbcliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbcliente` (
  `codigo` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cidade` varchar(45) NOT NULL,
  `uf` varchar(2) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbcliente`
--

LOCK TABLES `tbcliente` WRITE;
/*!40000 ALTER TABLE `tbcliente` DISABLE KEYS */;
INSERT INTO `tbcliente` VALUES (1,'João Silva','Recife','PE'),(2,'Maria Oliveira','São Paulo','SP'),(3,'Carlos Souza','Belo Horizonte','MG'),(4,'Ana Lima','Fortaleza','CE'),(5,'Pedro Rocha','Curitiba','PR'),(6,'Lucas Fernandes','Salvador','BA'),(7,'Juliana Martins','Brasília','DF'),(8,'Fernando Alves','Manaus','AM'),(9,'Camila Duarte','Porto Alegre','RS'),(10,'Rafael Costa','Belém','PA'),(11,'Bruna Nunes','João Pessoa','PB'),(12,'Marcelo Ramos','Vitória','ES'),(13,'Larissa Gomes','Maceió','AL'),(14,'Eduardo Moreira','Campo Grande','MS'),(15,'Isabela Freitas','São Luís','MA'),(16,'Vinícius Pires','Teresina','PI'),(17,'Letícia Barros','Aracaju','SE'),(18,'Rodrigo Teixeira','Natal','RN'),(19,'Bianca Mendes','Cuiabá','MT'),(20,'Thiago Neves','Florianópolis','SC'),(21,'Vanessa Cruz','Palmas','TO'),(22,'André Ribeiro','Goiânia','GO'),(23,'Patrícia Lima','Rio de Janeiro','RJ'),(24,'Diego Monteiro','Macapá','AP'),(25,'Sabrina Carvalho','Boa Vista','RR');
/*!40000 ALTER TABLE `tbcliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbitempedido`
--

DROP TABLE IF EXISTS `tbitempedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbitempedido` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `idpedido` int NOT NULL,
  `codproduto` int NOT NULL,
  `quantidade` float NOT NULL,
  `vlrunitario` float NOT NULL,
  `vlrtotal` float NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `idpedido` (`idpedido`),
  KEY `Produto_ItemPedido_idx` (`codproduto`),
  CONSTRAINT `Pedido_ItemPedido` FOREIGN KEY (`idpedido`) REFERENCES `tbpedido` (`idpedido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Produto_ItemPedido` FOREIGN KEY (`codproduto`) REFERENCES `tbproduto` (`codigo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbitempedido`
--

LOCK TABLES `tbitempedido` WRITE;
/*!40000 ALTER TABLE `tbitempedido` DISABLE KEYS */;
INSERT INTO `tbitempedido` VALUES (2,25060001,5,10,299.9,2999),(3,25060001,6,15,2599,38985);
/*!40000 ALTER TABLE `tbitempedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbpedido`
--

DROP TABLE IF EXISTS `tbpedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbpedido` (
  `idpedido` int NOT NULL,
  `dataemissao` datetime NOT NULL,
  `codcliente` int NOT NULL,
  `valortotal` float NOT NULL,
  PRIMARY KEY (`idpedido`),
  UNIQUE KEY `numpedido_UNIQUE` (`idpedido`),
  KEY `IdCliente_idx` (`codcliente`),
  CONSTRAINT `IdCliente` FOREIGN KEY (`codcliente`) REFERENCES `tbcliente` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbpedido`
--

LOCK TABLES `tbpedido` WRITE;
/*!40000 ALTER TABLE `tbpedido` DISABLE KEYS */;
INSERT INTO `tbpedido` VALUES (25060001,'2025-06-25 00:00:00',6,41984);
/*!40000 ALTER TABLE `tbpedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbproduto`
--

DROP TABLE IF EXISTS `tbproduto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbproduto` (
  `codigo` int NOT NULL,
  `descricao` varchar(45) NOT NULL,
  `precovenda` float NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbproduto`
--

LOCK TABLES `tbproduto` WRITE;
/*!40000 ALTER TABLE `tbproduto` DISABLE KEYS */;
INSERT INTO `tbproduto` VALUES (1,'Notebook Dell Inspiron 15 3000',3599.9),(2,'Monitor LG 24\" Full HD IPS',899),(3,'Mouse Logitech M280 Wireless',99.9),(4,'Teclado Mecânico Redragon Kumara',249),(5,'Headset Gamer HyperX Cloud Stinger',299.9),(6,'Smartphone Samsung Galaxy S21 FE',2599),(7,'Tablet Lenovo Tab M10 HD',999),(8,'HD Externo Seagate 1TB USB 3.0',349.9),(9,'SSD Kingston 480GB A400',229),(10,'Pendrive Sandisk 64GB USB 3.1',59.9),(11,'Impressora Multifuncional Epson EcoTank L3250',1049),(12,'Webcam Logitech C920 Full HD',499.9),(13,'Roteador TP-Link Archer C6 AC1200',239),(14,'Placa de Vídeo NVIDIA GTX 1660 Super',1699),(15,'Fonte Corsair CV550 550W 80 Plus Bronze',349.9),(16,'Placa-Mãe ASUS Prime B450M-GAMING',599),(17,'Processador AMD Ryzen 5 5600G',899),(18,'Memória RAM DDR4 8GB 3200MHz Corsair',199.9),(19,'Gabinete Gamer com LED RGB',279),(20,'Carregador Portátil (Power Bank) 10.000mAh',139),(21,'Smartwatch Amazfit Bip U Pro',349),(22,'Hub USB 4 Portas 3.0',79.9),(23,'Controle Xbox Series S/X Bluetooth',399),(24,'Caixa de Som Bluetooth JBL GO 3',229),(25,'Cabo HDMI 2.0 2m',29.9);
/*!40000 ALTER TABLE `tbproduto` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-25  0:37:13
