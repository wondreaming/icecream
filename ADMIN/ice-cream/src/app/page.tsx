"use client";

import { useEffect, useState } from "react";
import { useRouter, usePathname } from "next/navigation";
import { signOut, useSession } from "next-auth/react";
import io from "socket.io-client";

const SOCKET_SERVER_URL = `${process.env.NEXT_PUBLIC_SOCKET_SERVER_URL}`;

const Home = () => {
  const router = useRouter();
  const pathname = usePathname();
  const { data: session, status: sessionStatus } = useSession();
  const [cctvImage, setCctvImage] = useState<string | null>(null);
  const [cctvName, setCctvName] = useState<string>("오션초등학교 CCTV"); // cctv 이름
  const [speedDataList, setSpeedDataList] = useState<
    {
      time: string;
      speed: number;
    }[]
  >([]); // 시간과 속도 받을 리스트

  useEffect(() => {
    if (sessionStatus === "unauthenticated" && pathname !== "/login") {
      router.replace("/login");
    }
  }, [sessionStatus, router, pathname]);

  useEffect(() => {
    if (sessionStatus === "authenticated") {
      const socket = io(SOCKET_SERVER_URL);

      socket.on("connect", () => {
        console.log("Connected to WebSocket server.");
      });

      socket.on("getCCTVImage2", (data: { CCTVImage: ArrayBuffer }) => {
        // console.log("Received data from getCCTVImage2", data);
        // const blob = new Blob([data.CCTVImage], { type: "image/jpeg" });
        // const imageUrl = URL.createObjectURL(blob);
        // setCctvImage(imageUrl);
        const base64Image = arrayBufferToBase64(data.CCTVImage);
        setCctvImage(base64Image);
      });

      socket.on("getSpeedData", (data: { time: string; speed: number }) => {
        setSpeedDataList(prevList => [
          ...prevList,
          { time: data.time, speed: data.speed },
        ]);
      });

      return () => {
        socket.disconnect();
      };
    }
  }, [sessionStatus]);

  return (
    sessionStatus === "authenticated" && (
      <>
        <main className="h-screen overflow-hidden">
          <div className="grid grid-cols-8 h-full">
            <div className="col-span-6 flex items-center justify-center">
              <div className="w-full h-full flex flex-col items-center justify-center">
                <h1 className="absolute top-3 left-3 p-2 text-3xl">
                  {/* WebSocket CCTV Image Viewer */}
                  {cctvName}
                </h1>
                {cctvImage ? (
                  <img
                    src={`data:image/jpeg;base64,${cctvImage}`}
                    alt="CCTV"
                    // className="w-full h-full object-cover"
                  />
                ) : (
                  // <img src={cctvImage} alt="CCTV" />
                  <p className="text-xl">No image received yet.</p>
                )}
              </div>
            </div>
            {/* <div className="col-span-2">지도</div> */}
            <div className="col-span-2 bg-black flex flex-col justify-end items-center h-full">
              <h1 className="text-white text-2xl mt-10 hidden sm:block">
                관리자 페이지
              </h1>
              <h3 className="text-white mt-10 mb-5 text-4xl hidden sm:block">
                과속 발생 현황
              </h3>
              <div className="text-white flex-grow w-full overflow-y-auto px-5 flex flex-col justify-center items-center">
                {speedDataList.length > 0 ? (
                  speedDataList.map((data, index) => (
                    <div key={index} className="text-white">
                      <div>시간 : {data.time}</div>
                      <div>속도 : {data.speed} km/h</div>
                    </div>
                  ))
                ) : (
                  <p> 과속 차량이 없습니다</p>
                )}
              </div>
              <button
                className="p-2 px-10 btn-delete mt-auto mb-8"
                onClick={() => {
                  signOut();
                }}
              >
                로그아웃
              </button>
            </div>
          </div>
        </main>
      </>
    )
  );
};

export default Home;

function arrayBufferToBase64(buffer: ArrayBuffer): string {
  let binary = "";
  const bytes = new Uint8Array(buffer);
  const len = bytes.byteLength;
  for (let i = 0; i < len; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return window.btoa(binary);
}
