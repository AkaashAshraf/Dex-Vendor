class AppInfo {
  var id;
  var name;
  var aboutUs;
  var aboutUsEn;
  var colorTheme;
  var email;
  var phone;
  var whatsApp;
  var facebook;
  var minRequests;
  var createdAt;
  var updatedAt;
  var twitter;
  var privacyPolicy;
  var play;
  var terms;
  var termsEn;
  var linkedin;
  var insta;

  AppInfo(
      {this.id,
      this.name,
      this.aboutUs,
      this.aboutUsEn,
      this.colorTheme,
      this.email,
      this.phone,
      this.whatsApp,
      this.facebook,
      this.minRequests,
      this.createdAt,
      this.updatedAt,
      this.twitter,
      this.privacyPolicy,
      this.play,
      this.linkedin,
      this.insta,
      this.terms,
      this.termsEn,
      });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return new AppInfo(
        id: json['id'],
        name: json['name'],
        aboutUs: json['aboutUs'],
        aboutUsEn: json['aboutUsEng'] == null ? '' : json['aboutUsEng'],
        colorTheme: json['colorTheme'],
        email: json['email'],
        phone: json['phone'],
        whatsApp: json['whatsApp'],
        facebook: json['facebook'],
        minRequests: json['minRequests'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        twitter: json['twitter'],
        privacyPolicy: json['privacyPolicy'],
        play: json['googlePlayUrl'],
        linkedin: json['linkedin'],
        insta: json['instgram'],
        terms: json['userAgreement'],
        termsEn: json['UserAgreement_Eng']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['aboutUs'] = this.aboutUs;
    data['aboutUsEng'] = this.aboutUsEn;
    data['colorTheme'] = this.colorTheme;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['whatsApp'] = this.whatsApp;
    data['facebook'] = this.facebook;
    data['minRequests'] = this.minRequests;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['twitter'] = this.twitter;
    data['userAgreement'] = this.terms;
    data['UserAgreement_Eng'] = this.termsEn;
    data['instgram'] = this.insta;
    data['linkedin'] = this.linkedin;
    data['googlePlayUrl'] = this.play;
    return data;
  }
}
