# 달러모아 개인프로젝트 정리

<img width="281" alt="image" src="https://github.com/Jimmy-Jung/DollarMoreOpen/assets/115251866/021c7494-24d3-47e3-a18e-5167cfeda8be">

달러모아는 직관적이고 깔끔한 차트를 제공하여 달러 시장을 한눈에 볼 수 있는 앱입니다. 

국제 달러원, 달러인덱스, 하나은행 달러원 차트를 비교해서 볼 수 있어서 필요한 정보를 쉽게 찾을 수 있습니다.

또한, 달러모아는 다크모드를 지원하여 밤에도 눈이 편안한 UI를 제공합니다. 

국내외 채권 및 외환 시장의 최신 뉴스와 동향을 실시간으로 파악할 수 있는 기능도 있습니다.


# 기본 개념

이 앱은 MVVM과 Combine의 조합을 사용했다. Async/Await를 통한 직관적인 비동기코드를 전달합니다.


## 디자인 목표

- 테스트 가능성: MVVM 아키텍처를 통해 ViewController와 로직을 분리하고 의존성 주입 (DI)을 사용하여 코드를 테스트할 수 있습니다.
  
- 직관적인 코드: Combine을 사용하여 데이터 전달에 대한 델리게이트(delegate)나 클로저(closer) 대신 더 직관적인 코드를 제공합니다.
  또한 Async/Await을 사용하여 콜백 지옥을 극복하고 직관적인 비동기 코드를 사용합니다.
  
- 직관적인 UI: 앱의 디자인은 명확한 아이콘과 레이블을 통해 사용자를 다양한 기능으로 안내하는 사용하기 쉬운 구조로 구성합니다



---

# 앱의 구성

<img width="780" alt="image" src="https://github.com/Jimmy-Jung/DollarMoreOpen/assets/115251866/dcb10931-49c7-49d4-a1c1-cb18a2f53152">

<img width="776" alt="image" src="https://github.com/Jimmy-Jung/DollarMoreOpen/assets/115251866/69b6a695-b76c-435c-8c2e-d84c76ce69f6">


---

## 리뷰 요청 팝업 알람 띄우기

<img width="264" alt="image" src="https://github.com/Jimmy-Jung/DollarMoreOpen/assets/115251866/c840112e-1001-4777-b01b-3e2fb91f5269">

리뷰를 유도하는 팝업을 생성하여 사용자가 앱 리뷰를 작성할 수 있도록 했습니다.

이 페이지는 앱스토어 심사를 통과하고 사용자들에게 앱에 대한 피드백을 얻기 위해 중요합니다. 

이렇게 하면 사용자가 리뷰 작성 페이지로 쉽게 이동할 수 있으며, 앱스토어 심사에서도 문제가 발생하지 않습니다.


### SwiftRater

SwiftRater 라이브러리를 사용하여 앱스토어에서 앱에 대한 리뷰를 요청하는 팝업을 띄울 수 있습니다.


1. SwiftRater 라이브러리를 프로젝트에 추가합니다.
2. AppDelegate 파일에 다음과 같이 코드를 추가합니다.
   

```swift
import SwiftRater

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    SwiftRater.daysUntilPrompt = 5 // 앱을 시작한 이후 5일이 지난 후에 리뷰 요청
    SwiftRater.usesUntilPrompt = 5 // 앱을 실행한 횟수가 5회 이상일 때 리뷰 요청
    SwiftRater.significantUsesUntilPrompt = 3 // 앱 사용자가 앱에서 새로운 기능을 사용한 횟수가 3회 이상일 때 리뷰 요청
    SwiftRater.daysBeforeReminding = 1 // 리뷰 요청을 거절한 이후 1일이 지나면 다시 리뷰 요청
    SwiftRater.showLaterButton = true // "나중에" 버튼을 보여줍니다.
    SwiftRater.debugMode = true // 테스트에 유용한 디버그 모드에서 프롬프트가 표시되는지 여부를 결정합니다.
    SwiftRater.appLaunched() // 앱이 시작되었음을 라이브러리에 알리는 데 사용됩니다.
    return true
}
```


---

# 달러 차트

<img width="600" alt="image" src="https://github.com/Jimmy-Jung/DollarMoreOpen/assets/115251866/52596a60-8e80-41aa-b057-c56460ffd814">

차트는 Charts 라이브러리를 통해 제공됩니다.

두 개의 차트를 동시에 비교할 수 있는 듀얼 차트와,

지난 날의 종가와 함께 단순한 싱글 차트를 제공합니다.


### 문제와 해결

차트의 종류를 바꾸면 네트워킹을 통해 차트 데이터를 받아오는 도중에 차트가 뜨지 않는 문제가 발생했습니다.

이를 해결하기 위해 Singleton 객체를 만들어 최초 호출 시에만 로딩하고, 

그 이후에는 저장되어 있는 차트를 먼저 보여주고 네트워킹이 완료되면 차트를 업데이트하였습니다.


---

# UI 디자인

UI 디자인을 Storyboard를 사용하여 구현했습니다.

AutoLayout을 이용하여 자동으로 크기가 조절됩니다.

iPhone과 iPad에서 각각 최적화된 디자인과 텍스트 크기를 제공합니다.

<img width="250" alt="image" src="https://github.com/Jimmy-Jung/DollarMoreOpen/assets/115251866/3cee97a2-a3fd-48c2-b804-96c7f02405f1">
<img width="650" alt="image" src="https://github.com/Jimmy-Jung/DollarMoreOpen/assets/115251866/b6a53aa6-c6ea-4148-aafd-5720e079698d">


---


# 차트 데이터

<img width="450" alt="image" src="https://github.com/Jimmy-Jung/DollarMoreOpen/assets/115251866/4a5d3c83-019a-400d-bd9f-f7b7d7eac377">

차트 데이터는 YahooFinance API와 하나은행 웹 크롤링을 통해 제공됩니다.


## YahooFinance API

yahooFinance에서 제공하는 API URL을 URLSession을 사용해 데이터를 가져오는 방법은 다음과 같습니다.

1. URL을 작성합니다.
2. URL을 사용하여 URLSessionDataTask를 생성합니다.
3. URLSessionDataTask를 실행하고, 응답 데이터를 처리합니다.
4. 응답 데이터를 JSONSerialization을 사용하여 원하는 데이터 형식으로 변환합니다.
5. 변환된 데이터를 사용합니다.
   

### 하나은행 웹 크롤링

Alamofire와 SwiftSoup 라이브러리를 사용해 웹페이지를 크롤링하고 Struct로 변환해 데이터를 사용합니다.

하나은행 데이터를 크롤링하는 방법은 다음과 같습니다.

1. `Alamofire`와 `SwiftSoup` 라이브러리를 프로젝트에 추가합니다.
2. 크롤링할 웹페이지의 URL을 작성합니다.
3. `Alamofire`를 사용하여 URL에 GET 요청을 보냅니다.
4. 응답으로 받은 HTML 데이터를 `SwiftSoup`으로 파싱합니다.
5. 파싱한 데이터를 이용하여 데이터 모델을 만듭니다.
   

### 문제와 해결

하나은행을 크롤링할 때 GET 요청시 모바일로 요청하면 데이터를 받아올 수 없는 문제가 발생했습니다. 

이를 해결하기 위해 HTTPHeader를 수정하여 데스크탑으로 요청하였습니다.


---

# 뉴스 RSS

<img width="381" alt="image" src="https://github.com/Jimmy-Jung/DollarMoreOpen/assets/115251866/9f50f4df-4bdb-473d-94c2-5778eed49058">
 
차트 변동에 따른 실시간 뉴스를 제공하기 위해 연합인포맥스에서 제공하는 RSS데이터를 사용해 뉴스를 TableView로 제공합니다. 

뉴스를 클릭하면 SafariService를 통해 뉴스페이지로 이동합니다.

 `XMLParserDelegate` 프로토콜을 구현하여 `XMLParser` 객체를 사용하여 XML 데이터를 파싱합니다. 

파싱한 데이터는 `News` 구조체에 저장되며, `UITableView`를 사용하여 구성됩니다.
 

연합인포맥스에서 제공하는 뉴스 RSS 데이터를 사용하여 TableView를 생성하는 방법은 다음과 같습니다.

1. `XMLParserDelegate` 프로토콜을 구현하여 XML 데이터를 파싱합니다.
2. `URLSession` 객체를 사용하여 RSS 데이터를 다운로드합니다.
3. 다운로드한 데이터를 `XMLParser` 객체를 사용하여 파싱합니다.
4. 파싱한 데이터를 `News` 객체에 저장합니다.
5. `News` 객체를 사용하여 `UITableView`를 구성합니다.

