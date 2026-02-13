class BasicInfo {
  final String fullName;
  final String admissionNo;
  final String batch;
  final String semester;
  final String quota;
  final String gender;
  final String dob;
  final String religion;
  final String caste;
  final String nationality;
  final String place;
  final String imageUrl;

  BasicInfo({
    required this.fullName,
    required this.admissionNo,
    required this.batch,
    required this.semester,
    required this.quota,
    required this.gender,
    required this.dob,
    required this.religion,
    required this.caste,
    required this.nationality,
    required this.place,
    required this.imageUrl,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      fullName: json['fullName'] ?? '',
      admissionNo: json['admissionNo'] ?? '',
      batch: json['batch'] ?? '',
      semester: json['semester'] ?? '',
      quota: json['quota'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      religion: json['religion'] ?? '',
      caste: json['caste'] ?? '',
      nationality: json['nationality'] ?? '',
      place: json['place'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class ParentInfo {
  final String fatherName;
  final String fatherOccupation;
  final String fatherEmail;
  final String fatherMobile;

  final String motherName;
  final String motherOccupation;
  final String motherEmail;
  final String motherMobile;

  ParentInfo({
    required this.fatherName,
    required this.fatherOccupation,
    required this.fatherEmail,
    required this.fatherMobile,
    required this.motherName,
    required this.motherOccupation,
    required this.motherEmail,
    required this.motherMobile,
  });

  factory ParentInfo.fromJson(Map<String, dynamic> json) {
    return ParentInfo(
      fatherName: json['fatherName'] ?? '',
      fatherOccupation: json['fatherOccupation'] ?? '',
      fatherEmail: json['fatherEmail'] ?? '',
      fatherMobile: json['fatherMobile'] ?? '',
      motherName: json['motherName'] ?? '',
      motherOccupation: json['motherOccupation'] ?? '',
      motherEmail: json['motherEmail'] ?? '',
      motherMobile: json['motherMobile'] ?? '',
    );
  }
}

class ContactInfo {
  final String permanentAddress;
  final String communicationAddress;
  final String email1;
  final String email2;
  final String mobile;

  ContactInfo({
    required this.permanentAddress,
    required this.communicationAddress,
    required this.email1,
    required this.email2,
    required this.mobile,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      permanentAddress: json['permanentAddress'] ?? '',
      communicationAddress: json['communicationAddress'] ?? '',
      email1: json['email1'] ?? '',
      email2: json['email2'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}

class ProfileDetails {
  final BasicInfo basic;
  final ParentInfo parent;
  final ContactInfo contact;

  ProfileDetails({
    required this.basic,
    required this.parent,
    required this.contact,
  });

  factory ProfileDetails.fromJson(Map<String, dynamic> json) {
    return ProfileDetails(
      basic: BasicInfo.fromJson(json['basic']),
      parent: ParentInfo.fromJson(json['parent']),
      contact: ContactInfo.fromJson(json['contact']),
    );
  }
}