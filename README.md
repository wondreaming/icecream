# 🍧 IceCream
<img src="./docs/icecream.png" alt="whale1" width="200" height="200">

### 자녀들의 안전한 보행을 위한 교통안전 앱

##### 기획 의도
  - 스쿨존 내 교통사고 예방
  - 사용자(아이들)의 횡단보도 사용을 유도

##### 서비스 요약
  - 횡단보도 구역 내에 있을 경우, 과속 차량에 대한 알림 신호
  - 자녀의 위치를 부모가 알 수 있게 함
  - 자녀가 미리 설정해둔 영역에 도착 시 부모에게 알림 발송
  - 무단횡단 시 부모에게 알림 발송
  - 스마트폰과 워치를 연동하여 빠르고 쉽게 알림 확인 가능
</br>

## 🕞 프로젝트 진행 기간
**2024.04.08 ~ 2024.05.20** (6주)

<br>

## 💬 주요 기능
**1. 과속 차량에 대한 위험 알림**
    (1) 과속 차량 탐지 
   - 실시간으로 찍은 CCTV 영상을 GPU 서버로 보냄
   - GPU 서버에서 YOLOv9를 통해서, 차량 객체 감지와 차량의 속도를 파악
   - 과속 차량 발생 시 RabbitMQ로 과속이 발생한 cctv_name과 speed 데이터 전송 
   - 백엔드 서버에서 과속이 발생한 cctv_name과 speed 데이터 수집 
   - 어린이 보호 구역 제한 속도를 기준으로 위험 알림 메시지 생성
   - 기본 속도 30 이상 overspeed-1 / 35 이상 overspeed-2 / 45 이상 overspeed-3 파악 
   - cctv_name과 매핑된 횡단보도 조회 (cctv 근처에 위치한 횡단보도 조회) 
   - 과속 차량 인근 횡단보도 영역에 위치한 자녀에게 FCM을 통해 위험 알림 전송
    
   (2) 과속 위험 알림 대상자 판별
  - RabbitMQ의 GPS 데이터를 수집하여 보행자가 특정 횡단보도 영역에 위치하는지 판별
  - 특정 횡단보도에 위치하는 경우 Redis에 기록 

**2. 자녀 목적지 도착시, 부모 어플에 알림 전송**
   - 부모가 자녀의 앱 활성화 시간(=자녀 등하교 시간), 목적지 지정
   - 스케줄링을 통하여, 활성화 시간동안 자녀 휴대폰에서 RabbitMQ로 GPS 데이터 전송(1번/초)
   - 자녀 목적지 도착 시,  FCM를 통해 부모 어플로 자녀 도착 알림 메시지 전달
   - 부모는 자녀의 앱 활성화 시간동안 자녀의 실시간 위치 조회 가능

**3. 자녀 무단 횡단시, 부모 / 자녀에게 알림 전송**
   - 무단 횡단 영역을 PostgresSQL에 저장 (4326좌표계를 기준)
   - RabbitMQ의 GPS 데이터를 수집하여 자녀가 무단 횡단 영역에 위치하는지 파악
   - 자녀가 무단 횡단영역에 위치 하였을 때, FCM를 통해 부모 / 자녀에게 무단횡단 알림 발송


<br>

## 📱 서비스 화면
|                       앱 진입 화면                       |
| :------------------------------------------------------: |
|                     <img src="./docs/서비스화면/앱진입화면.jpg" style="height: 450px">                      |
| 부모 / 자녀를 선택해서</br> 서비스를 이용할 수 있다 |

|       부모 회원가입       |        자녀 QR 생성         |      자녀 QR 등록      |
| :-------------------: | :---------------------------: | :------------------------: |
|    <img src="./docs/서비스화면/부모회원가입.png" style="height: 450px">     |        <img src="./docs/서비스화면/자녀등록QR.png" style="height: 450px">         |      <img src="./docs/서비스화면/QR등록.png" style="height: 450px">        |
| 부모 회원가입 화면 | 자녀 등록을 위한 자녀 QR 생성 | 부모의 기기에서 자녀의 QR 등록으로 자녀 회원가입  |

※ 최초등록 이후 디바이스 ID를 통해 자동 로그인

|     부모 메인 화면      |      자녀 마커 클릭 시       |
| :---------------------: | :--------------------------: |
|     <img src="./docs/서비스화면/부모메인.jpg" style="height: 450px">      |       <img src="./docs/서비스화면/자녀마커클릭.jpg" style="height: 450px">         |
| 자신과 자녀의 위치 확인 | 자녀의 정보와 위치 확인 가능 |

|        안전 지킴이        |                     리워드 관리                      |
| :-----------------------: | :--------------------------------------------------: |
|      <img src="./docs/서비스화면/안전지킴이.jpg" style="height: 450px">       |                   <img src="./docs/서비스화면/리워드관리.jpg" style="height: 450px">                     |
| 자녀의 횡단보도 사용 확인 | 자녀의 횡단보도 사용에 대한 <br> 리워드 등록 및 수정 |

|    알림 내역 확인     |
| :-------------------: |
|    <img src="./docs/서비스화면/알림내역.jpg" style="height: 450px">     |
| 일자별 알림 내역 확인 |

|       자녀 목록       |        자녀 상세 정보         |      자녀 목적지 관리      |
| :-------------------: | :---------------------------: | :------------------------: |
|    <img src="./docs/서비스화면/자녀목록.jpg" style="height: 450px">     |        <img src="./docs/서비스화면/자녀상세.jpg" style="height: 450px">         |      <img src="./docs/서비스화면/자녀목적지.jpg" style="height: 450px">        |
| 등록된 자녀 목록 확인 | 자녀의 상세 정보 조회 및 수정 | 자녀의 목적지 등록 및 수정 |

|    관리자 페이지     |
| :-------------------: |
|    <img src="./docs/서비스화면/관리자 과속 감지.png" style="height: 450px">     |
| AI를 활용해 CCTV를 통한 차량의 속도 측정 </br> 과속 발생 시 사용자에게 위험 알림 전송  |

|                       과속 알림 화면                       |
| :------------------------------------------------------: |
|                     <img src="./docs/서비스화면/과속알림.png" style="height: 450px">                      |
| 과속 발생 시, 스마트폰 및 스마트워치에 위험 알림 전송 |


<br>
<br>

## 👩‍💻 개발 환경

<a name="item-three"></a>

|일정관리|형상관리|커뮤니케이션|디자인|
|:---:|:---:|:---:|:---:|
| ![JIRA](https://img.shields.io/badge/jira-0052CC?style=for-the-badge&logo=jirasoftware&logoColor=white) | ![GITLAB](https://img.shields.io/badge/gitlab-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white) |![MatterMost](https://img.shields.io/badge/MatterMost-346ac1?style=for-the-badge&logo=MatterMost&logoColor=white) ![Notion](https://img.shields.io/badge/Notion-%23000000.svg?style=for-the-badge&logo=notion&logoColor=white) | ![Figma](https://img.shields.io/badge/figma-%23F24E1E.svg?style=for-the-badge&logo=figma&logoColor=white) |



<br>


#### IDE

![VSCode](https://img.shields.io/badge/VisualStudioCode-007ACC?style=for-the-badge&logo=VisualStudioCode&logoColor=white) ![Android Studio](https://img.shields.io/badge/android%20studio-346ac1?style=for-the-badge&logo=android%20studio&logoColor=white)
![IntelliJ](https://img.shields.io/badge/intellijidea-000000?style=for-the-badge&logo=intellijidea&logoColor=white)

<br>


#### Frontend
![JavaScript](https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E) ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white) 
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=Flutter&logoColor=white) ![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white) ![TailwindCSS](https://img.shields.io/badge/tailwindcss-%2338B2AC.svg?style=for-the-badge&logo=tailwind-css&logoColor=white) 
![Firebase](https://img.shields.io/badge/firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white)

<br>


#### Backend

![Java](https://img.shields.io/badge/java-%23ED8B00.svg?style=for-the-badge&logo=openjdk&logoColor=white)  
![SpringBoot](https://img.shields.io/badge/springboot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white) ![JWT](https://img.shields.io/badge/JWT-black?style=for-the-badge&logo=JSON%20web%20tokens) ![SpringSecurity](https://img.shields.io/badge/springsecurity-6DB33F?style=for-the-badge&logo=springsecurity&logoColor=white)  
![AmazonS3](https://img.shields.io/badge/AmazonS3-569A31?style=for-the-badge&logo=AmazonS3&logoColor=white) ![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white) ![Redis](https://img.shields.io/badge/redis-DC382D?style=for-the-badge&logo=redis&logoColor=white) 
![RabbitMQ](https://img.shields.io/badge/Rabbitmq-FF6600?style=for-the-badge&logo=rabbitmq&logoColor=white) ![ElasticSearch](https://img.shields.io/badge/-ElasticSearch-005571?style=for-the-badge&logo=elasticsearch) 
![Next JS](https://img.shields.io/badge/Next-black?style=for-the-badge&logo=next.js&logoColor=white) ![Express.js](https://img.shields.io/badge/express.js-%23404d59.svg?style=for-the-badge&logo=express&logoColor=%2361DAFB) ![TypeScript](https://img.shields.io/badge/typescript-%23007ACC.svg?style=for-the-badge&logo=typescript&logoColor=white) 

<br>

#### AI 
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54) ![FastAPI](https://img.shields.io/badge/fastapi-009688?style=for-the-badge&logo=fastapi&logoColor=white)  ![PyTorch](https://img.shields.io/badge/PyTorch-%23EE4C2C.svg?style=for-the-badge&logo=PyTorch&logoColor=white) ![NumPy](https://img.shields.io/badge/numpy-%23013243.svg?style=for-the-badge&logo=numpy&logoColor=white) 	![OpenCV](https://img.shields.io/badge/opencv-%23white.svg?style=for-the-badge&logo=opencv&logoColor=white) ![Socket.io](https://img.shields.io/badge/Socket.io-black?style=for-the-badge&logo=socket.io&badgeColor=010101)


#### DevOPS

![docker](https://img.shields.io/badge/docker-2496ED?style=for-the-badge&logo=docker&logoColor=white) ![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=Jenkins&logoColor=white) ![nginx](https://img.shields.io/badge/nginx-009639?style=for-the-badge&logo=nginx&logoColor=white) ![amazonec2](https://img.shields.io/badge/amazonec2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white) 

<br>

## 🏢 ER Diagram
<img src="./docs/ERD.png">

## 🏢 아키텍처
<img src="./docs/icecream_architecture.png">



## 📑 프로젝트 산출물
- [아키텍처](./docs/icecream_architecture.png)
- [요구사항-기능 명세서](https://swamp-shaker-ff8.notion.site/39e2fa39bcd443a089e8906058a0056b?v=fa6777d377164e7dbbc40f70032615a7)
- [API 명세서](https://swamp-shaker-ff8.notion.site/API-1582f6714d75481c9570fe2654d21666)  
- [와이어프레임](https://www.figma.com/design/YQuvNP8ix8z96yOsAmGpBU/%EC%95%84%EC%9D%B4%EC%8A%A4%ED%81%AC%EB%A6%BC?node-id=67-690&t=xTt8Ec62LzmAH2Q3-1)
- [포팅메뉴얼](./exec/PortingManual.md)
- [UCC](./docs/UCC.mp4)
- [시연영상](./docs/시연영상.mp4)


## 👨‍👨‍👧👨‍👨‍👧 팀원
|BE|BE|BE|FE|FE|FE|AI|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|**이재진**|**정종길**|**심상익**|**유영준**|**황채원**|**서준하**|**김민진**|
| <img src="./docs/팀원/재진.png" style="height: 100px"> | <img src="./docs/팀원/종길.png" style="height: 100px"> | <img src="./docs/팀원/상익.png" style="height: 100px"> | <img src="./docs/팀원/영준.png" style="height: 100px"> | <img src="./docs/팀원/채원.png" style="height: 100px"> | <img src="./docs/팀원/준하.png" style="height: 100px"> | <img src="./docs/팀원/민진.png" style="height: 100px"> |
| 팀장 <br/> BackEnd <br/> Infra <br/> GPU서버| BankEnd <br/> Security <br/> MQ 구축 <br/> | BackEnd <br/> ELK 스택 <br/> 관리자page <br/> GPU서버<br/>| FrontEnd <br/> FCM <br/> Design | Frontend <br/> WebSocket <br/> CCTV구축 | FrontEnd <br/> GPS <br/> | Yolo <br/> 객체 추적 <br/> 객체 속도 <br/> |
