/*
Mental Health Services Data Set (MHSDS) denormalisation query.

See: mhsds.md

This is an SQL query that will convert the many tables in the MHSDS into a single table.

The table and field names are determined by the MHSDS v5.0 Technical Output Specification (TOS).

For more information about the MHSDS, see:
https://digital.nhs.uk/data-and-information/data-collections-and-data-sets/data-sets/mental-health-services-data-set

*/
-- Vertically merge (append) Ward Stay and Care Contact using UNION.
WITH (
  -- MHS502 Ward Stay
  SELECT
     WardStay.WardStayId -- M502915 WARD STAY IDENTIFIER
    ,WardStay.StartDateWardStay -- START DATE (WARD STAY)
    ,WardStay.StartTimeWardStay
    ,WardStay.EndDateMHTrialLeave
    ,WardStay.EndDateWardStay
    ,WardStay.EndTimeWardStay
    ,WardStay.SiteIDOfTreat
    ,WardStay.WardType
    ,WardStay.WardAge
    ,WardStay.WardSexTypeCode
    ,WardStay.IntendClinCareIntenCodeMH
    ,WardStay.WardSecLevel
    ,WardStay.LockedWardInd
    ,WardStay.HospitalBedTypeMH
    ,WardStay.SpecialisedMHServiceCode
    ,WardStay.WardCode
      
    -- MHS501 Hospital Provider Spell
    ,HospitalProviderSpell.HospProvSpellID -- HOSPITAL PROVIDER SPELL IDENTIFIER
    ,HospitalProviderSpell.DecidedToAdmitDate
    ,HospitalProviderSpell.DecidedToAdmitTime
    ,HospitalProviderSpell.StartDateHospProvSpell
    ,HospitalProviderSpell.StartTimeHospProvSpell
    ,HospitalProviderSpell.SourceAdmMHHospProvSpell
    ,HospitalProviderSpell.MethAdmMHHospProvSpell
    ,HospitalProviderSpell.PostcodeMainVisitor
    ,HospitalProviderSpell.EstimatedDischDateHospProvSpell
    ,HospitalProviderSpell.PlannedDischDateHospProvSpell
    ,HospitalProviderSpell.PlannedDestDisch
    ,HospitalProviderSpell.DischDateHospProvSpell
    ,HospitalProviderSpell.DischTimeHospProvSpell
    ,HospitalProviderSpell.MethOfDischMHHospProvSpell
    ,HospitalProviderSpell.DestOfDischHospProvSpell
    ,HospitalProviderSpell.PostcodeDischDestHospProvSpell
    ,HospitalProviderSpell.TransformingCareInd
    ,HospitalProviderSpell.TransformingCareCategory
    
    -- Blank fields from Care Contact that aren't shared
    ,NULL AS CareContactId
    
  FROM MHS502WardStay AS WardStay
  -- MHS501 Hospital Provider Spell
  LEFT JOIN MHS501HospProvSpell AS HospitalProviderSpell
    ON WardStay.HospProvSpellID = HospitalProviderSpell.HospProvSpellID
) AS WardStayEpisode

WITH (
  -- MHS201 Care Contact
  SELECT
     MHS201CareContact.CareContactId
    ,MHS201CareContact.ServiceRequestId
    ,MHS201CareContact.CareProfTeamLocalId
    ,MHS201CareContact.CareContDate
    ,MHS201CareContact.CareContTime
    ,MHS201CareContact.OrgIDComm
    ,MHS201CareContact.AdminCatCode
    ,MHS201CareContact.SpecialisedMHServiceCode
    ,MHS201CareContact.ClinContDurOfCareCont
    ,MHS201CareContact.ConsType
    ,MHS201CareContact.CareContSubj
    ,MHS201CareContact.ConsMechanismMH
    ,MHS201CareContact.ActLocTypeCode
    ,MHS201CareContact.PlaceOfSafetyInd
    ,MHS201CareContact.SiteIDOfTreat
    ,MHS201CareContact.ComPeriMHPartAssessOfferInd
    ,MHS201CareContact.PlannedCareContIndicator
    ,MHS201CareContact.CareContPatientTherMode
    ,MHS201CareContact.AttendOrDNACode
    ,MHS201CareContact.EarliestReasonOfferDate
    ,MHS201CareContact.EarliestClinAppDate
    ,MHS201CareContact.CareContCancelDate
    ,MHS201CareContact.CareContCancelReas
    ,MHS201CareContact.ReasonableAdjustmentMade
  FROM MHS201CareContact
) AS CareContactEpisode

-- Create a merged episode record
WITH (
  SELECT * FROM WardStayEpisode
  UNION
  SELECT * FROM CareContactEpisode
) AS Episode


SELECT

  -- TODO
  
  -- MHS101 Service or Team Referral
  ,Referral.ServiceRequestId -- SERVICE REQUEST IDENTIFIER
  ,Referral.LocalPatientId -- M101901 LOCAL PATIENT IDENTIFIER
  ,Referral.OrgIDComm -- M101922 ORGANISATION IDENTIFIER (CODE OF COMMISSIONER)
  ,Referral.ReferralRequestReceivedDate -- M101010 REFERRAL REQUEST RECEIVED DATE
  ,Referral.ReferralRequestReceivedTime
  ,Referral.NHSServAgreeLineNum
  ,Referral.SpecialisedMHServiceCode
  ,Referral.SourceOfReferralMH
  ,Referral.OrgIDReferring
  ,Referral.ReferringCareProfessionalStaffGroup
  ,Referral.ClinRespPriorityType
  ,Referral.PrimReasonReferralMH
  ,Referral.ReasonOAT
  ,Referral.DecisionToTreatDate
  ,Referral.DecisionToTreatTime
  ,Referral.DischPlanCreationDate
  ,Referral.DischPlanCreationTime
  ,Referral.DischPlanLastUpdatedDate
  ,Referral.DischPlanLastUpdatedTime
  ,Referral.ServDischDate
  ,Referral.ServDischTime

  -- MHS001 Master Patient Index
  ,Patient.LocalPatientId -- M001901 LOCAL PATIENT IDENTIFIER (EXTENDED)
  ,Patient.OrgIDLocalPatientId -- M001170 ORGANISATION IDENTIFIER (LOCAL PATIENT IDENTIFIER)
  ,Patient.OrgIDEduEstab -- M001190 ORGANISATION IDENTIFIER (EDUCATIONAL ESTABLISHMENT)
  ,Patient.NHSNumber
  ,Patient.NHSNumberStatus
  ,Patient.PersonBirthDate
  ,Patient.Postcode
  ,Patient.GenderIDCode
  ,Patient.GenderSameAtBirth
  ,Patient.Gender
  ,Patient.MaritalStatus
  ,Patient.EthnicCategory
  ,Patient.EthnicCategory2021
  ,Patient.LanguageCodePreferred
  ,Patient.PersDeathDate

FROM Episode;
-- MHS101 Service or Team Referral
LEFT INNER JOIN MHS101Referral AS Referral
  ON HospitalProviderSpell.ServiceRequestId = Referral.ServiceRequestId
-- MHS001 Master Patient Index
LEFT INNER JOIN MHS001MPI AS Patient
  Referral.LocalPatientId = Patient.LocalPatientId
