/*
Mental Health Services Data Set (MHSDS) denormalisation query.

This is an SQL query that will convert the many tables in the MHSDS into a single table.

The table and field names are determined by the MHSDS v5.0 Technical Output Specification (TOS).

For more information about the MHSDS, see:
https://digital.nhs.uk/data-and-information/data-collections-and-data-sets/data-sets/mental-health-services-data-set

*/
SELECT
  -- MHS502 Ward Stay
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

  -- MHS501 Hospital Provider Spel
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
  ,Patient.OrgIDLocalPatientId -- M001170	ORGANISATION IDENTIFIER (LOCAL PATIENT IDENTIFIER)
  ,Patient.OrgIDEduEstab -- M001190	ORGANISATION IDENTIFIER (EDUCATIONAL ESTABLISHMENT)
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

-- MHS502 Ward Stay
FROM MHS502WardStay AS WardStay;
-- MHS501 Hospital Provider Spell
LEFT INNER JOIN MHS501HospProvSpell AS HospitalProviderSpell
  ON WardStay.HospProvSpellID = HospitalProviderSpell.HospProvSpellID
-- MHS101 Service or Team Referral
LEFT INNER JOIN MHS101Referral AS Referral
  ON HospitalProviderSpell.ServiceRequestId = Referral.ServiceRequestId
-- MHS001 Master Patient Index
LEFT INNER JOIN MHS001MPI AS Patient
  Referral.LocalPatientId = Patient.LocalPatientId
