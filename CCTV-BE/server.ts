// server framework
const express = require("express");
const app = express();
// socket.io
const { createServer } = require("http");
const { Server } = require("socket.io");
const server = createServer(app);
const io = new Server(server);
// view engine
app.set("view engine", "ejs");

require("dotenv").config(); // .env 파일에서 환경변수 불러오기
const port = process.env.PORT || 8050;
const roomName = process.env.roomName || "chatRoom";

// server port
server.listen(port, "0.0.0.0", () => {
  console.log("port에 서버 연결됨");
});

// room에 입장할 수 있는 제한인원 3명으로 설정
const roomCapacity = { [roomName]: 0 };
const maxRoomCapacity = 3;

// router
app.get("/", (req, res) => {
  res.send("it is for websocket");
});

app.get("/cctv", (req, res) => {
  // 초기 데이터 설정
  const initialData = {
    CCTVName: "CCTV 위치",
    CCTVImage: null,
  };
  res.render("cctv", { data: initialData }); // 'data' 객체를 전달
});

// socket.io
io.on("connect", socket => {
  console.log("user가 websocket에 들어왔습니다");
  // 인원 수 검증
  if (roomCapacity[roomName] < maxRoomCapacity) {
    // 방 참여
    socket.join(roomName);
    roomCapacity[roomName]++;
    console.log("현재 방에 참여한 인원", roomCapacity[roomName]);

    // cctv 이미지 받고 전송
    socket.on("sendCCTVImage", data => {
      io.to(roomName).emit("getCCTVImage", data);
    });

    // 방 퇴장
    socket.on("disconnect", data => {
      roomCapacity[roomName]--;
      console.log("user가 websocket에서 나갔습니다");
    });
  } else {
    socket.emit("error", "방이 가득찼습니다");
  }
});
