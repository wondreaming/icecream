"use client";

import { use, useEffect, useState } from "react";
import { useRouter, usePathname } from "next/navigation";
import { signOut, useSession } from "next-auth/react";
import io from "socket.io-client";
import { set } from "mongoose";

const SOCKET_SERVER_URL = `${process.env.NEXT_PUBLIC_SOCKET_SERVER_URL}`;

const Home = () => {
  const router = useRouter();
  const pathname = usePathname();
  const { data: session, status: sessionStatus } = useSession();
  const [cctvImage, setCctvImage] = useState<string | null>(null);

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

      return () => {
        socket.disconnect();
      };
    }
  }, [sessionStatus]);

  return (
    sessionStatus === "authenticated" && (
      <>
        <main className="flex mx-auto max-w-[1290px] min-h-screen flex-col items-center p-24">
          <button
            className="absolute top-2 right-2 p-2 btn-delete"
            onClick={() => {
              signOut();
            }}
          >
            로그아웃
          </button>
          <h1>관리자 페이지</h1>
          <div>
            <h1>WebSocket CCTV Image Viewer</h1>
            {cctvImage ? (
              <img src={`data:image/jpeg;base64,${cctvImage}`} alt="CCTV" />
            ) : (
              // <img src={cctvImage} alt="CCTV" />
              <p>No image received yet.</p>
            )}
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
