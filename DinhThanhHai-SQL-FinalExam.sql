DROP DATABASE IF EXISTS QL_DiemHocSinh;
CREATE DATABASE QL_DiemHocSinh;
USE QL_DiemHocSinh;

DROP TABLE IF EXISTS `Student`;
CREATE TABLE `Student` (
	ID	 		SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	`Name`		VARCHAR(50) NOT NULL,
	Age 		TINYINT NOT NULL,
	Gender 		CHAR(5) NOT NULL
);

DROP TABLE IF EXISTS `Subject`;
CREATE TABLE `Subject` (
	ID	 		SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	`Name`		VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS `StudentSubject`;
CREATE TABLE `StudentSubject` (
	StudentID	SMALLINT UNSIGNED NOT NULL,
	SubjectID	SMALLINT UNSIGNED NOT NULL,
	Mark 		TINYINT UNSIGNED NOT NULL,
	`Date` 		DATETIME NOT NULL,
	FOREIGN KEY (StudentID) 	REFERENCES `Student`(ID),
	FOREIGN KEY (SubjectID) 	REFERENCES `Subject`(ID)
);
    
/* Insert student */
INSERT INTO `QL_DiemHocSinh`.`Student` 		(`Name`			, `Age`	, `Gender`	) 
VALUES 										('Student 1'	, '12'	, 'Nam'		),
											('Student 2'	, '13'	, 'Nu'		),
											('Student 3'	, '14'	, 'Nam'		);
 SELECT * FROM QL_DiemHocSinh.Student;  
 
/* Insert subject */			
INSERT INTO `QL_DiemHocSinh`.`Subject` 	(`Name`		)
VALUES 									('Subject 1'),
										('Subject 2'),
										('Subject 3');
SELECT * FROM QL_DiemHocSinh.`Subject`;										


/* Insert student subject*/
INSERT INTO `QL_DiemHocSinh`.`StudentSubject` 		(`StudentID`, `SubjectID`, `Mark` , 	`Date`					) 
VALUES 												( 1         ,  1         , '8' 	  , 	'2021-05-12 00:00:00'	),
													( 2         ,  1         , '9' 	  ,	    '2021-05-11 00:00:00'	),
													( 3         ,  1         , '10'   ,	    '2021-05-14 00:00:00'	);
SELECT * FROM QL_DiemHocSinh.StudentSubject;                                                 
                                                    
												
-- Select all subject that dont having any marks
SELECT su.`Name` FROM `StudentSubject` AS ss
RIGHT JOIN `Subject` AS su ON ss.SubjectID = su.ID
WHERE ss.Mark IS NULL;

-- Select all subject that have at least 2 marks
SELECT su.`Name` FROM `StudentSubject` AS ss
JOIN `Subject` AS su ON ss.SubjectID = su.ID
GROUP BY ss.SubjectID
HAVING COUNT(ss.Mark) >= 2;


-- Create view
DROP VIEW IF EXISTS StudentInfo;
CREATE VIEW StudentInfo AS
SELECT 	st.ID AS "Student ID",
		su.ID AS "Subject ID",
        st.`Name` AS "Student Name",
        st.Age AS "Student Age", 
        st.Gender, 
		CASE
			WHEN st.Gender = "Nam" THEN 0
			WHEN st.Gender = "Nu" THEN 1
			WHEN st.Gender = "Unknow" THEN NULL
		END AS "Student Gender",
        su.`Name` AS "Subject Name", 
        ss.Mark, 
        ss.`Date` 
FROM `Student` AS st
JOIN `StudentSubject` as ss ON ss.StudentID = st.ID
JOIN `Subject` as su ON ss.SubjectID = su.ID;
SELECT * FROM StudentInfo;
                                    

SET SQL_SAFE_UPDATES = 0;
-- Create trigger
DROP TRIGGER IF EXISTS SubjectUpdateID;
DELIMITER $$
CREATE TRIGGER SubjectUpdateID
AFTER UPDATE ON Student FOR EACH ROW
BEGIN
	IF OLD.ID <> NEW.ID THEN
		UPDATE `StudentSubject` AS ss
        SET ss.StudentID = NEW.ID
        WHERE ss.StudentID = OLD.ID;
        END IF;
END $$
DELIMITER ;


DROP TRIGGER IF EXISTS StudentDeleteID
DELIMITER $$
CREATE TRIGGER StudentDeleteID
AFTER DELETE ON Student FOR EACH ROW
BEGIN
	DELETE FROM `StudentSubject` AS ss
	WHERE ss.StudentID = OLD.ID;
END$$
DELIMITER ;



-- Create Procedure
DROP PROCEDURE IF EXISTS myProcedure;

DELIMITER $$
CREATE PROCEDURE myProcedure(IN studentName VARCHAR(100))
	BEGIN
		IF studentName = "*" THEN
			DELETE FROM `Student` AS st
            WHERE st.ID <> -1;
		ELSE 
			DELETE FROM `Student` AS st
            WHERE st.`Name` = studentName;
            END IF;
    END$$
DELIMITER ;

SET SQL_SAFE_UPDATES = 1;
