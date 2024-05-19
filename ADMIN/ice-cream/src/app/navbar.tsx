import React from "react";
import Link from "next/link";
import { signOut } from "next-auth/react";

const Navbar: React.FC = () => {
  return (
    <nav className="w-full bg-black text-white p-4 flex justify-between fixed top-0 z-10">
      <div className="flex space-x-8 text-2xl">
        <Link href="/" className="hover:text-gray-400 ml-5">
          ADMIN
        </Link>
        <Link
          href="https://k10e202.p.ssafy.io/kibana"
          className="hover:text-gray-400"
        >
          KIBANA
        </Link>
        <Link
          href="http://k10e202.p.ssafy.io:9090/login?from=%2F"
          className="hover:text-gray-400"
        >
          JENKINS
        </Link>
      </div>
      <div className="ml-auto">
        <button
          className="p-1 px-10 btn-delete text-xl" // text-2xl로 글자 크기 조정
          onClick={() => {
            signOut();
          }}
        >
          로그아웃
        </button>
      </div>
    </nav>
  );
};

export default Navbar;
