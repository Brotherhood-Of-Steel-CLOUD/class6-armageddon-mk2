import Image from "next/image";

export default function Home() {
  return (
    <main
      style={{
        backgroundColor: "#f3e5f5",
        minHeight: "100vh",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
      }}
    >
      <h1 style={{ color: "#6a1b9a", fontSize: "2.5rem" }}>
        Hello World from App 3
      </h1>
    </main>
  );
}
