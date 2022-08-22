

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents(
      {required this.title, required this.image, required this.desc});
}

List<OnboardingContents> contents = [
  OnboardingContents(
    // title: "Track Your work and get the result",
    title: "مرحباً بك في تطبيق حرفة وفنّ",
    image: "assets/splash1.png",
    // desc: "Remember to keep track of your professional accomplishments.",
    desc: "يُمكنك التطبيق من عرض الحرف والمهارات  ",
  ),
  OnboardingContents(
    // title: "Stay organized with team",
    title: "اضف اعمالك واحصل على النتائج",
    image: "assets/splash2.png",
    desc: "تذكر دوماً متابعة انجازاتك الإحترافية",
  ),
  OnboardingContents(
    // title: "Get notified when work happens",
    title: "احصل على تحكم كامل بجميع اعمالك ",
    image: "assets/splash3.png",
    // desc:"Take control of notifications, collaborate live or on your own time.",
    desc:"ويوفر لك الاستخدام السهل لعرض اعمالك وإدارتها",
   
  ),
];
