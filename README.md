# एजंट हिशोब — पूर्ण Build-Ready Flutter प्रकल्प

हा प्रकल्प Android APK तयार करण्यासाठी तयार केला आहे.

## मुख्य बदल
- दिनांक निवडण्याचा बॉक्स नाही; आजचा दिनांक वर दिसतो.
- 50+ एजंटसाठी शोध सुविधा.
- इंग्रजीत एजंटचे नाव लिहिल्यास मराठी लिपीत रूपांतर करण्याचा प्रयत्न.
- संपूर्ण UI मराठीत.
- बाजारांची नावे ठरलेली आहेत आणि बदलता येत नाहीत.
- देणे/घेणे फक्त अंक.
- एका रांगेत एकाच बाजूला रक्कम.
- रिकाम्या जागी `-`.
- एकूण, मागची बाकी आणि अंतिम रक्कम आपोआप.
- हिशोबाचा फोटो तयार करून WhatsApp वर शेअर करता येतो.

## APK तयार करण्याचा सर्वात सोपा मार्ग — GitHub

1. हा प्रकल्प GitHub repository मध्ये upload करा.
2. `.github/workflows/build-apk.yml` workflow सुरू करा.
3. GitHub Actions Flutter Android project तयार करून release APK build करेल.
4. Actions मधील `agent-hisab-apk` artifact download करा.
5. APK मोबाईलमध्ये install करा.

## PC वर Flutter असल्यास

```bash
flutter create --platforms=android .
flutter pub get
flutter build apk --release
```

APK:

`build/app/outputs/flutter-apk/app-release.apk`

## महत्त्वाची WhatsApp सूचना

सध्या फोटो तयार करून Android च्या शेअर पर्यायातून WhatsApp निवडता येतो. कोणत्याही बाहेरील API शिवाय एखाद्या विशिष्ट WhatsApp Group मध्ये फोटो पूर्णपणे पार्श्वभूमीत आपोआप पाठवणे शक्य नाही. त्यासाठी स्वतंत्र WhatsApp-compatible backend/integration आणि योग्य अधिकृत access आवश्यक आहे.
