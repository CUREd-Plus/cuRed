/*
Mental Health Services Data Set (MHSDS) denormalisation query.

This is an SQL query that will convert the many tables in the MHSDS into a single table.

For more information about the MHSDS, see:
https://digital.nhs.uk/data-and-information/data-collections-and-data-sets/data-sets/mental-health-services-data-set

*/
SELECT
  -- Ward Stay
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
  -- Hospital Provider Spell
  ,WardStay.HospProvSpellID -- M502160 HOSPITAL PROVIDER SPELL IDENTIFIER
  ,HospitalProviderSpell.ServiceRequestId -- M501902 SERVICE REQUEST IDENTIFIER
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
FROM MHS502WardStay AS WardStay;
LEFT JOIN MHS501HospProvSpell AS HospitalProviderSpell
  ON WardStay.HospProvSpellID = HospitalProviderSpell.HospProvSpellID
