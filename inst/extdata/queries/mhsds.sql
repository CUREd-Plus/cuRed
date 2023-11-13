/*
Mental Health Services Data Set (MHSDS) denormalisation query.

For documentation, please read mhsds.md
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
    ,HospitalProviderSpell.ServiceRequestId
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
    ,NULL AS CareProfTeamLocalId
    ,NULL AS CareContDate
    ,NULL AS CareContTime
    ,NULL AS OrgIDComm
    ,NULL AS AdminCatCode
    ,NULL AS ClinContDurOfCareCont
    ,NULL AS ConsType
    ,NULL AS CareContSubj
    ,NULL AS ConsMechanismMH
    ,NULL AS ActLocTypeCode
    ,NULL AS PlaceOfSafetyInd
    ,NULL AS ComPeriMHPartAssessOfferInd
    ,NULL AS PlannedCareContIndicator
    ,NULL AS CareContPatientTherMode
    ,NULL AS AttendOrDNACode
    ,NULL AS EarliestReasonOfferDate
    ,NULL AS EarliestClinAppDate
    ,NULL AS CareContCancelDate
    ,NULL AS CareContCancelReas
    ,NULL AS ReasonableAdjustmentMade
    
  FROM MHS502WardStay AS WardStay
  -- MHS501 Hospital Provider Spell
  LEFT JOIN MHS501HospProvSpell AS HospitalProviderSpell
    ON WardStay.HospProvSpellID = HospitalProviderSpell.HospProvSpellID
) AS WardStayEpisode

WITH (
  -- MHS201 Care Contact
  SELECT
    -- Insert missing columns for Ward Stay
     NULL AS WardStayId
    ,NULL AS StartDateWardStay
    ,NULL AS StartTimeWardStay
    ,NULL AS EndDateMHTrialLeave
    ,NULL AS EndDateWardStay
    ,NULL AS EndTimeWardStay
    ,NULL AS SiteIDOfTreat
    ,NULL AS WardType
    ,NULL AS WardAge
    ,NULL AS WardSexTypeCode
    ,NULL AS IntendClinCareIntenCodeMH
    ,NULL AS WardSecLevel
    ,NULL AS LockedWardInd
    ,NULL AS HospitalBedTypeMH
    ,NULL AS SpecialisedMHServiceCode
    ,NULL AS WardCode
    ,NULL AS HospProvSpellID
    ,NULL AS ServiceRequestId
    ,NULL AS DecidedToAdmitDate
    ,NULL AS DecidedToAdmitTime
    ,NULL AS StartDateHospProvSpell
    ,NULL AS StartTimeHospProvSpell
    ,NULL AS SourceAdmMHHospProvSpell
    ,NULL AS MethAdmMHHospProvSpell
    ,NULL AS PostcodeMainVisitor
    ,NULL AS EstimatedDischDateHospProvSpell
    ,NULL AS PlannedDischDateHospProvSpell
    ,NULL AS PlannedDestDisch
    ,NULL AS DischDateHospProvSpell
    ,NULL AS DischTimeHospProvSpell
    ,NULL AS MethOfDischMHHospProvSpell
    ,NULL AS DestOfDischHospProvSpell
    ,NULL AS PostcodeDischDestHospProvSpell
    ,NULL AS TransformingCareInd
    ,NULL AS TransformingCareCategory
    ,CareContact.CareContactId
    ,CareContact.ServiceRequestId
    ,CareContact.CareProfTeamLocalId
    ,CareContact.CareContDate
    ,CareContact.CareContTime
    ,CareContact.OrgIDComm
    ,CareContact.AdminCatCode
    ,CareContact.SpecialisedMHServiceCode
    ,CareContact.ClinContDurOfCareCont
    ,CareContact.ConsType
    ,CareContact.CareContSubj
    ,CareContact.ConsMechanismMH
    ,CareContact.ActLocTypeCode
    ,CareContact.PlaceOfSafetyInd
    ,CareContact.SiteIDOfTreat
    ,CareContact.ComPeriMHPartAssessOfferInd
    ,CareContact.PlannedCareContIndicator
    ,CareContact.CareContPatientTherMode
    ,CareContact.AttendOrDNACode
    ,CareContact.EarliestReasonOfferDate
    ,CareContact.EarliestClinAppDate
    ,CareContact.CareContCancelDate
    ,CareContact.CareContCancelReas
    ,CareContact.ReasonableAdjustmentMade
  FROM MHS201CareContact AS CareContact
) AS CareContactEpisode

-- Create a merged episode record
WITH (
  SELECT * FROM WardStayEpisode
  UNION
  SELECT * FROM CareContactEpisode
) AS Episode

SELECT

  -- Episode (= Ward Stay UNION Care Contact)
  -- EpisodeId is a new primary key for this data set (it should be unique)
  COALESCE(Episode.WardStayId, Episode.CareContactId) AS EpisodeId
  ,Episode.WardStayId
  ,Episode.StartDateWardStay
  ,Episode.StartTimeWardStay
  ,Episode.EndDateMHTrialLeave
  ,Episode.EndDateWardStay
  ,Episode.EndTimeWardStay
  ,Episode.SiteIDOfTreat
  ,Episode.WardType
  ,Episode.WardAge
  ,Episode.WardSexTypeCode
  ,Episode.IntendClinCareIntenCodeMH
  ,Episode.WardSecLevel
  ,Episode.LockedWardInd
  ,Episode.HospitalBedTypeMH
  ,Episode.SpecialisedMHServiceCode
  ,Episode.WardCode
  ,Episode.HospProvSpellID
  ,Episode.ServiceRequestId
  ,Episode.DecidedToAdmitDate
  ,Episode.DecidedToAdmitTime
  ,Episode.StartDateHospProvSpell
  ,Episode.StartTimeHospProvSpell
  ,Episode.SourceAdmMHHospProvSpell
  ,Episode.MethAdmMHHospProvSpell
  ,Episode.PostcodeMainVisitor
  ,Episode.EstimatedDischDateHospProvSpell
  ,Episode.PlannedDischDateHospProvSpell
  ,Episode.PlannedDestDisch
  ,Episode.DischDateHospProvSpell
  ,Episode.DischTimeHospProvSpell
  ,Episode.MethOfDischMHHospProvSpell
  ,Episode.DestOfDischHospProvSpell
  ,Episode.PostcodeDischDestHospProvSpell
  ,Episode.TransformingCareInd
  ,Episode.TransformingCareCategory
  ,Episode.CareContactId
  ,Episode.ServiceRequestId
  ,Episode.CareProfTeamLocalId
  ,Episode.CareContDate
  ,Episode.CareContTime
  ,Episode.OrgIDComm
  ,Episode.AdminCatCode
  ,Episode.SpecialisedMHServiceCode
  ,Episode.ClinContDurOfCareCont
  ,Episode.ConsType
  ,Episode.CareContSubj
  ,Episode.ConsMechanismMH
  ,Episode.ActLocTypeCode
  ,Episode.PlaceOfSafetyInd
  ,Episode.SiteIDOfTreat
  ,Episode.ComPeriMHPartAssessOfferInd
  ,Episode.PlannedCareContIndicator
  ,Episode.CareContPatientTherMode
  ,Episode.AttendOrDNACode
  ,Episode.EarliestReasonOfferDate
  ,Episode.EarliestClinAppDate
  ,Episode.CareContCancelDate
  ,Episode.CareContCancelReas
  ,Episode.ReasonableAdjustmentMade
  
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

  -- MHS202 Care Activity
  ,CareActivity.CareActId
  ,CareActivity.CareProfLocalId
  ,CareActivity.ClinContactDurOfCareAct
  ,CareActivity.CodeProcAndProcStatus
  ,CareActivity.FindSchemeInUse
  ,CareActivity.CodeFind
  ,CareActivity.CodeObs
  ,CareActivity.ObsValue
  ,CareActivity.UnitMeasure

  -- MHS203 Other in Attendance
  ,OtherInAttendance.OtherPersonInAttend
  ,OtherInAttendance.ReasonPatientNoIMCA
  ,OtherInAttendance.ReasonPatientNoIMHA

  -- MHS607 Coded Scored Assessment (Care Activity)
  ,CodedScoredAssessment.CodedAssToolType
  ,CodedScoredAssessment.PersScore
  
  -- MHS204 Indirect Activity
  ,IndirectActivity.CareProfTeamLocalId
  ,IndirectActivity.IndirectActDate
  ,IndirectActivity.IndirectActTime
  ,IndirectActivity.DurationIndirectAct
  ,IndirectActivity.OrgIDComm
  ,IndirectActivity.CareProfLocalId
  ,IndirectActivity.CodeIndActProcAndProcStatus
  ,IndirectActivity.FindSchemeInUse
  ,IndirectActivity.CodeFind
  
  -- MHS107 Medication Prescription
  ,MedicationPrescription.ServiceRequestId
  ,MedicationPrescription.PrescriptionID
  ,MedicationPrescription.PrescriptionDate
  ,MedicationPrescription.PrescriptionTime
  
  -- MHS106 Discharge Plan Agreement
  -- TODO

FROM Episode
-- MHS202 Care Activity
LEFT JOIN MHS202CareActivity AS CareActivity
  ON Episode.CareContactId = CareActivity.CareContactId
-- MHS203 Other in Attendance
LEFT JOIN MHS203OtherAttend AS OtherInAttendance
  ON Episode.CareContactId = OtherInAttendance.CareContactId
-- MHS607 Coded Scored Assessment (Care Activity)
LEFT JOIN MHS607CodedScoreAssessmentAct AS CodedScoredAssessment
  ON CareActivity.CareActId = CodedScoredAssessment.CareActId
-- MHS101 Service or Team Referral
LEFT JOIN MHS101Referral AS Referral
  ON HospitalProviderSpell.ServiceRequestId = Referral.ServiceRequestId
-- MHS001 Master Patient Index
LEFT JOIN MHS001MPI AS Patient
  Referral.LocalPatientId = Patient.LocalPatientId
-- MHS204 Indirect Activity
LEFT JOIN MHS204IndirectActivity AS IndirectActivity
  ON Referral.ServiceRequestId = IndirectActivity.ServiceRequestId
-- MHS107 Medication Prescription
LEFT JOIN MHS107MedicationPrescription AS MedicationPrescription
  ON Referral.ServiceRequestId = MedicationPrescription.ServiceRequestId
-- MHS106 Discharge Plan Agreement
-- TODO
;
