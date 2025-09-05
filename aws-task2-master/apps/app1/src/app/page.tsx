import Image from "next/image";

export default function Home() {
  return (
    <main
      style={{
        backgroundColor: "#e0f7fa",
        minHeight: "100vh",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
      }}
    >
      <h1 style={{ color: "#006064", fontSize: "2.5rem" }}>
        Hello World from App 1
      </h1>
    </main>
  );
}
