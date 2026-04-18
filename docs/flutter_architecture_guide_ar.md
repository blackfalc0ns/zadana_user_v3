# دليل عملي لاختيار أفضل Architecture في Flutter

## الهدف من هذا الملف

هذا الدليل يجاوب على سؤال مهم جدًا:

"أشتغل في Flutter بأي طريقة؟ MVVM؟ Clean Architecture؟ ولا مزيج بسيط بينهم؟ وهل أستخدم Retrofit و json_serializable أم لا؟"

الهدف هنا ليس إعطاءك كلام أكاديمي فقط، بل إعطاءك طريقة عملية تمشي بها في المشاريع الحقيقية بدون over-engineering.

---

## الخلاصة السريعة

أفضل طريقة عامة لمعظم مشاريع Flutter المتوسطة والكبيرة هي:

**Clean Architecture Lite + MVVM in Presentation**

بمعنى:

- `data`: API, DTOs, mappers, repository implementation
- `domain`: entities, repository contracts, use cases
- `presentation`: UI + state management + view models/cubits

هذا ليس Clean Architecture المعقدة جدًا، وليس MVVM الخام فقط.
هو مزيج عملي ممتاز:

- منظم
- سهل التطوير
- سهل التوسع
- لا يسبب تعقيدًا زائدًا من البداية

---

## هل MVVM وحدها كافية؟

نعم، في المشاريع الصغيرة والبسيطة جدًا.

لكن مع زيادة الشاشات ووجود API كثيرة وbusiness rules أكثر، MVVM وحدها غالبًا تصبح ضعيفة في:

- فصل المسؤوليات
- اختبار المنطق
- إعادة استخدام الـ business logic
- منع تداخل الـ UI مع data layer

لذلك MVVM وحدها ممتازة للتطبيقات الصغيرة أو الـ prototype، لكنها ليست دائمًا الأفضل على المدى المتوسط والطويل.

---

## هل Clean Architecture الكاملة هي الأفضل دائمًا؟

لا.

الكثير يظن أن Clean Architecture الكاملة هي "أفضل شيء على الإطلاق"، لكن الحقيقة:

- ممتازة جدًا في المشاريع الكبيرة
- ممتازة في فرق العمل
- ممتازة في المشاريع طويلة العمر

لكنها قد تتحول إلى over-engineering لو المشروع:

- صغير
- عدد شاشاته قليل
- الـ API بسيطة
- أنت ما زلت تتعلم

المشكلة ليست في الفكرة نفسها، بل في المبالغة في التطبيق.

---

## الطريقة الأفضل عمليًا

### اسم الطريقة المقترحة

**Feature-first Clean MVVM**

أو بالعربي:

**هيكلة بالـ feature مع فصل data/domain/presentation واستخدام ViewModel أو Cubit داخل presentation**

---

## الشكل المقترح للمجلدات

```text
lib/
  core/
    network/
    utils/
    widgets/
    errors/
    constants/

  feature/
    auth/
      data/
        data_source/
        models/
        mapper/
        repo/
      domain/
        entities/
        repo/
        usecase/
      presentation/
        pages/
        widgets/
        manager/

    home/
      data/
      domain/
      presentation/
```

هذه الطريقة ممتازة لأنها:

- تجعل كل feature مستقلة
- تسهل التنقل داخل المشروع
- تمنع اختلاط ملفات features ببعض
- تجعل refactor أسهل كثيرًا

---

## ماذا أضع في كل طبقة؟

## 1. presentation

هذه الطبقة فيها:

- pages
- widgets
- view models أو cubits أو blocs
- states
- events لو تستخدم event-based logic

مسؤوليتها:

- عرض البيانات
- استقبال interaction من المستخدم
- استدعاء الـ use case
- تحويل النتيجة لحالة UI

مهم جدًا:

presentation لا تتعامل مع API مباشرة.

---

## 2. domain

هذه الطبقة هي قلب المنطق.

فيها:

- entities
- repository contracts
- use cases

وظيفتها:

- تمثل business logic الحقيقي
- تكون مستقلة عن Flutter وعن الـ API implementation

مثال:

- `LoginUseCase`
- `GetHomeDataUseCase`
- `ProfileRepository`

---

## 3. data

هذه الطبقة فيها:

- remote data source
- local data source إن وجد
- DTO models
- mappers
- repository implementation

هذه الطبقة تتعامل مع:

- Dio / Retrofit
- JSON
- SharedPreferences
- SecureStorage
- أي مصدر بيانات خارجي

---

## أين يذهب MVVM هنا؟

MVVM عندك يكون داخل `presentation`.

يعني:

- `View` = page + widgets
- `ViewModel` = Cubit أو ChangeNotifier أو ViewModel class
- `Model` = ليس DTO model هنا، بل البيانات التي تصل للواجهة من domain/entities أو mapped UI state

أقوى تطبيق عملي في Flutter اليوم غالبًا هو:

- `Clean Architecture` في تقسيم الطبقات
- `MVVM / Cubit / Bloc` في presentation

هذا هو التوازن الأفضل.

---

## هل أستخدم Cubit أم ViewModel عادي؟

لو أنت تستخدم `flutter_bloc` بالفعل:

**Cubit ممتاز جدًا**

لأنه:

- بسيط
- واضح
- مناسب لمعظم الشاشات
- أقل تعقيدًا من Bloc الكامل

توصيتي:

- استخدم `Cubit` أو `ViewModel` event-based خفيف
- لا تستخدم Bloc الكامل إلا عند الحاجة الفعلية

---

## هل أستخدم UseCase دائمًا؟

ليس دائمًا في المشاريع الصغيرة.

لكن في مشروع متوسط أو كبير:

نعم، الأفضل أن يكون عندك use case لكل عملية مهمة مثل:

- login
- register
- get profile
- update profile
- fetch home banners

السبب:

- يفصل الـ UI عن repository
- يسهل الاختبار
- يسهل التوسع لاحقًا

---

## هل أستخدم Retrofit و json_serializable؟

### الإجابة العملية

نعم، هما ممتازان.

لكن:

**ليسا شرطًا من أول يوم**

إذا كنت لا تزال لا تفهمهما جيدًا، فلا تجعل تعلمهما يوقفك عن بناء المشروع.

---

## متى يكون Retrofit + json_serializable خيارًا ممتازًا؟

عندما:

- يكون عندك API كثيرة
- responses كثيرة
- DTOs كثيرة
- تريد تقليل الكتابة اليدوية
- تريد consistency في parsing

الفوائد:

- يقلل boilerplate
- يجعل الـ serialization أوضح
- يجعل network layer أنظف
- مناسب جدًا للمشاريع المتوسطة والكبيرة

---

## متى لا أبدأ بهما الآن؟

لو أنت:

- ما زلت تتعلم Flutter architecture
- تتوه أصلًا بين الطبقات
- ما زلت غير مرتاح لـ Dio نفسه
- المشروع ما زال صغيرًا

فالأفضل أن تبدأ أولًا بـ:

- `Dio`
- parsing يدوي بسيط
- models واضحة
- mappers واضحة

ثم بعد أن تستقر البنية:

تنتقل إلى `json_serializable`
ثم بعد ذلك إلى `retrofit`

---

## التدرج الأفضل لك شخصيًا

### المرحلة 1

ابدأ هكذا:

- `Dio`
- `fromJson/toJson` يدويًا
- `data/domain/presentation`
- `Cubit` في presentation

هذه أفضل بداية تعليمية.

### المرحلة 2

عندما تشعر أن كتابة `fromJson` مملة:

- أدخل `json_serializable`
- ابدأ في الـ DTOs فقط

### المرحلة 3

عندما يصبح عندك API service كبيرة:

- أدخل `Retrofit`

هذا التدرج أفضل كثيرًا من القفز إلى كل الأدوات دفعة واحدة.

---

## ما هي الأدوات الشبكية الأفضل عمومًا؟

### الأفضل عمليًا لمعظم مشاريع Flutter

- `dio`
- `json_serializable`
- `build_runner`
- `retrofit` (اختياري لكنه قوي)

### التوصية الواقعية

- مشروع صغير: `dio` فقط يكفي
- مشروع متوسط: `dio + json_serializable`
- مشروع كبير: `dio + json_serializable + retrofit`

---

## ما وظيفة كل package؟

### dio

مكتبة HTTP قوية لطلبات الشبكة.

### json_annotation

Annotations تستخدم مع json_serializable.

### json_serializable

توليد `fromJson` و `toJson` تلقائيًا.

### build_runner

الأداة التي تشغل التوليد البرمجي.

### retrofit

يبني لك API client مرتب جدًا باستخدام annotations فوق methods.

### retrofit_generator

المولد البرمجي الخاص بـ retrofit.

---

## لماذا تشعر أن هذه الطريقة صعبة؟

لأن فيها جزئين مختلفين:

1. فهم architecture نفسها
2. فهم code generation

وأنت غالبًا تحاول تعلم الاثنين معًا في نفس الوقت.

وهذا يسبب تشويشًا.

الحل:

تعلمهما على مرحلتين.

---

## أفضل طريقة تعلم

### أولًا

افهم هذا التسلسل:

`UI -> ViewModel/Cubit -> UseCase -> Repository -> DataSource -> API`

إذا فهمت هذا التسلسل جيدًا، يصبح الباقي أسهل كثيرًا.

### ثانيًا

طبق نفس التسلسل مرة يدويًا بدون generators.

### ثالثًا

بعد أن تستوعب الصورة، أدخل generators.

---

## مثال عملي مبسط للتدفق

```text
LoginScreen
  -> LoginCubit
  -> LoginUseCase
  -> AuthRepository
  -> AuthRemoteDataSource
  -> Dio API call
  -> LoginResponseDto
  -> LoginEntity
  -> LoginState
  -> UI
```

هذا هو التدفق الذي يجب أن تحفظه وتفهمه.

---

## ما الذي لا أنصحك به؟

### 1. لا تخلط UI مع API

خطأ شائع:

- استدعاء Dio داخل الصفحة مباشرة

هذا يجعل المشروع يتعب بسرعة.

### 2. لا تبالغ في الطبقات

إذا كانت العملية بسيطة جدًا، لا تبنِ 7 ملفات من أجل شيء صغير جدًا.

### 3. لا تنسخ Clean Architecture من الإنترنت حرفيًا

خذ الفكرة، لا تنسخ التعقيد.

### 4. لا تبدأ بـ Retrofit إذا كنت لا تفهم Dio

افهم الأصل أولًا.

---

## الصيغة التي أوصي بها لك الآن

بناءً على مستواك الحالي ووصفك أنك ما زلت غير مرتاح لـ:

- retrofit
- json_serializable
- build_runner

فأنا أوصيك الآن بهذا:

### النسخة المناسبة لك الآن

**Clean Architecture Lite**

```text
feature/
  xxx/
    data/
      data_source/
      models/
      mapper/
      repo/
    domain/
      entities/
      repo/
      usecase/
    presentation/
      pages/
      widgets/
      manager/
```

وفي `data`:

- استخدم `Dio`
- استخدم parsing يدوي بسيط في البداية

وفي `presentation`:

- استخدم `Cubit` أو ViewModel

وبعد أن تثبت:

- أضف `json_serializable`
- ثم أضف `retrofit`

---

## متى تنقل المشروع إلى Retrofit؟

انقل عندما تجد نفسك تفعل الآتي كثيرًا:

- نفس request code يتكرر
- fromJson/toJson كثيرة جدًا
- API interfaces كبيرة
- تحتاج consistency أكبر

وقتها سيكون الانتقال مفيدًا فعلًا.

---

## أفضل اختيار نهائي بدون over-engineering

إذا سألتني:

"ما أفضل طريقة على الإطلاق بشكل عملي ومتوازن؟"

فإجابتي هي:

**Feature-first + Clean Architecture Lite + Cubit in Presentation + Dio**

ثم لاحقًا:

**أضف json_serializable**

ثم لاحقًا:

**أضف Retrofit إذا احتجت**

هذا هو المسار الأذكى، لأنه:

- لا يربكك
- لا يضخم المشروع
- يبقي المشروع محترمًا
- يسمح لك بالنمو بدون إعادة بناء كل شيء

---

## ترتيب التعلّم الذي أوصيك به

1. افهم `data / domain / presentation`
2. افهم التدفق: `UI -> ViewModel -> UseCase -> Repository -> DataSource`
3. ابنِ feature أو اثنتين يدويًا باستخدام Dio
4. بعد أن تثبت الفكرة، تعلم `json_serializable`
5. بعد ذلك فقط تعلم `retrofit`

---

## القرار النهائي

### لو المشروع صغير جدًا

استخدم:

- `presentation + data`
- بدون domain لو أردت

### لو المشروع متوسط أو كبير

استخدم:

- `data + domain + presentation`
- Cubit أو ViewModel في presentation
- Dio أولًا
- ثم generators لاحقًا

### لو أنت ما زلت تتعلم

لا تبدأ من أول يوم بـ:

- retrofit
- json_serializable
- build_runner
- generator-heavy architecture

ابدأ بالبنية النظيفة أولًا.

---

## آخر نصيحة مهمة

لا تبحث عن "أفخم architecture".
ابحث عن:

- architecture مفهومة
- قابلة للاستمرار
- تناسب حجم المشروع
- تناسب مستواك الحالي

أفضل architecture هي التي تستطيع أنت استخدامها بثبات، وليس التي تبدو احترافية على الورق فقط.

---

## التوصية النهائية المختصرة جدًا

**ابدأ الآن بـ Clean Architecture Lite + Cubit + Dio**

ثم:

**تعلم json_serializable**

ثم:

**أدخل Retrofit عندما تصبح API layer كبيرة فعلًا**

