USE [BusinessLicenceApplications]
GO
/****** Object:  StoredProcedure [dbo].[sp_submitApplication]    Script Date: 9/8/2025 10:07:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
/**
Name   : dbo.sp_submitApplication
 
Date   : Aug 27, 2025
Author : Logan Zetaruk
Purpose: Add BusYears
 
Date   : June 20, 2025
Author : Ted Corpus
Purpose: add Business licence submission to database
Require: dbo.f_GetSessionID() to get the SubmissionID (a random number)
**/
ALTER       PROC [dbo].[sp_submitApplication](
   @ApplicationSessionID    varchar(100)
  ,@BusName                 varchar(255)
  ,@BusAddress              varchar(255)
  ,@BusPhone                varchar(20)
  ,@BusEmail                varchar(255)
  ,@Website                 varchar(500)  NULL
  ,@BusYears                smallint      NULL
  ,@BusMailingAddress       varchar(255)  NULL
  ,@CorporateName           varchar(255)  NULL
  ,@IncorpNumber            varchar(50)   NULL
  ,@TQNumber                varchar(50)   NULL
  ,@BusDescription          varchar(500)  NULL
  ,@BusType                 varchar(100)  NULL
  ,@IsIntermunicipal        bit           NULL
  ,@IsSecondarySuite        bit           NULL
  ,@IsClientsOnSite         bit           NULL
  ,@NumChildren             smallint      NULL
  ,@DayCareLocation         varchar(100)  NULL
  ,@BusArea                 float         NULL
  ,@EmpCount                smallint      NULL
  ,@IsRenovating            bit           NULL
  ,@RenoDesc                varchar(500)  NULL
  ,@IsInstallSignage        bit           NULL
  ,@IsAlarmOnSite           bit           NULL
  ,@NonResLocation          varchar(500)  NULL
  ,@NonResStartDate         date          NULL
  ,@NonResEndDate           date          NULL
  ,@IsCorrespondCityInfo    bit           NULL
  ,@IsCorrespondEcoDev      bit           NULL
  ,@IsCorrespondPubEngage   bit           NULL
  ,@IsCorrespondWSCC        bit           NULL
  ,@Owner1Name              varchar(255)
  ,@Owner1Address           varchar(255)  NULL
  ,@Owner1Phone             varchar(50)   NULL
  ,@Owner1Email             varchar(255)  NULL
  ,@Owner2Name              varchar(255)  NULL
  ,@Owner2Address           varchar(255)  NULL
  ,@Owner2Phone             varchar(50)   NULL
  ,@Owner2Email             varchar(255)  NULL
) AS
BEGIN 
  SET NOCOUNT ON
  DECLARE 
     @newID         int
    ,@rndSeed       varchar(50)
    ,@submissionID  varchar(50)
  ;
  INSERT INTO dbo.ApplicationSubmission (
   ApplicationSessionID 
  ,BusName              
  ,BusAddress           
  ,BusPhone             
  ,BusEmail             
  ,Website   
  ,BusYears
  ,BusMailingAddress    
  ,CorporateName        
  ,IncorpNumber
  ,TQNumber         
  ,BusDescription       
  ,BusType
  ,IsIntermunicipal     
  ,IsSecondarySuite     
  ,IsClientsOnSite      
  ,NumChildren   
  ,DayCareLocation         
  ,BusArea              
  ,EmpCount             
  ,IsRenovating         
  ,RenoDesc             
  ,IsInstallSignage     
  ,IsAlarmOnSite        
  ,NonResLocation       
  ,NonResStartDate      
  ,NonResEndDate        
  ,IsCorrespondCityInfo 
  ,IsCorrespondEcoDev   
  ,IsCorrespondPubEngage
  ,IsCorrespondWSCC     
  ,Owner1Name           
  ,Owner1Address        
  ,Owner1Phone          
  ,Owner1Email          
  ,Owner2Name           
  ,Owner2Address        
  ,Owner2Phone          
  ,Owner2Email                   
  ) SELECT
   @ApplicationSessionID 
  ,@BusName              
  ,@BusAddress           
  ,@BusPhone             
  ,@BusEmail             
  ,@Website    
  ,@BusYears
  ,@BusMailingAddress    
  ,@CorporateName        
  ,@IncorpNumber    
  ,@TQNumber     
  ,@BusDescription       
  ,@BusType
  ,@IsIntermunicipal     
  ,@IsSecondarySuite     
  ,@IsClientsOnSite      
  ,@NumChildren 
  ,@DayCareLocation         
  ,@BusArea              
  ,@EmpCount             
  ,@IsRenovating         
  ,@RenoDesc             
  ,@IsInstallSignage     
  ,@IsAlarmOnSite        
  ,@NonResLocation       
  ,@NonResStartDate      
  ,@NonResEndDate        
  ,@IsCorrespondCityInfo 
  ,@IsCorrespondEcoDev   
  ,@IsCorrespondPubEngage
  ,@IsCorrespondWSCC     
  ,@Owner1Name           
  ,@Owner1Address        
  ,@Owner1Phone          
  ,@Owner1Email          
  ,@Owner2Name           
  ,@Owner2Address        
  ,@Owner2Phone          
  ,@Owner2Email          
  ;
  SET @newID = SCOPE_IDENTITY();  ----this must be immediately after the INSERT statement
  SELECT @rndSeed = Replace(Replace(Replace(Convert(varchar(22),ApplicationDate,26),'-',''),' ',''),':','') +  Reverse(Right('000000000000'+Convert(varchar(8),ApplicationID),8)) FROM dbo.ApplicationSubmission WHERE ApplicationID = @newID;
  SET @submissionID = dbo.f_GetSubmissionID(@rndSeed);
  UPDATE dbo.ApplicationSubmission SET SubmissionID = @submissionID WHERE ApplicationID = @newID;
  SELECT 1 as ReturnValue, @submissionID as SubmissionID
END