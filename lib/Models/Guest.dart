  class Guest {
   String? nationality;
  String? documentType;
  String? gender;
  String? name;
  String? documentID;
  String? birthPlace;
  DateTime? dateOfBirth;

 Guest ({required String newNationality, required String newDocumentType, 
required String newGender, 
required String newName, required String newDocumentID, required String newBirthPlace, required DateTime newDateOfBirth})
{
    nationality = newNationality;
    documentType = newDocumentType;
    gender = newGender;
    name = newName;
    documentID = newDocumentID;
    birthPlace = newBirthPlace;
    dateOfBirth = newDateOfBirth;
}
 }
