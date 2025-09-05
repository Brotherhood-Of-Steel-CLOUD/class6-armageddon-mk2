import Image from "next/image";

export default function Home() {
  return (
    <main
      style={{
        backgroundColor: "#fff3e0",
        minHeight: "100vh",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
      }}
    >
      <h1 style={{ color: "#e65100", fontSize: "2.5rem" }}>
        Hello World from App 2
      </h1>
    </main>
  );
}
