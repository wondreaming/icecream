"use client";
import React from "react";
import { SessionProvider } from "next-auth/react";

interface AuthProviderProps {
	children: React.ReactNode;
}

const AuthProvider = ({ children }: AuthProviderProps) => {
	return (
		<SessionProvider refetchOnWindowFocus={false}>{children}</SessionProvider>
	);
};

export default AuthProvider;
