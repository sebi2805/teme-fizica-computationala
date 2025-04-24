import React, { Suspense, useRef, useState, useEffect } from "react";
import * as THREE from "three";
import { Canvas, useFrame } from "@react-three/fiber";
import { OrbitControls, Stars, useGLTF } from "@react-three/drei";

interface TwoBodyData {
  time_unit: string;
  position_unit: string;
  time: number[];
  body1_positions: number[][]; // Soarele
  body2_positions: number[][]; // Pământul
}

const SunModel: React.FC = () => {
  const { scene } = useGLTF("/sun.glb");
  return <primitive object={scene} scale={[0.1, 0.1, 0.1]} />;
};

const EarthModel: React.FC = () => {
  const { scene } = useGLTF("/earth.glb");
  return <primitive object={scene} scale={[0.1, 0.11, 0.11]} />;
};

const TwoBodySimulation: React.FC = () => {
  const sunRef = useRef<THREE.Group>(null!);
  const earthRef = useRef<THREE.Group>(null!);
  const [data, setData] = useState<TwoBodyData | null>(null);

  useEffect(() => {
    fetch("/twoBodyData.json")
      .then((res) => res.json())
      .then((json: TwoBodyData) => setData(json))
      .catch(console.error);
  }, []);

  useFrame(({ clock }) => {
    if (!data) return;
    const { time, body1_positions, body2_positions } = data;
    const dt = time[1] - time[0];
    const tMax = time[time.length - 1];
    const elapsed = clock.getElapsedTime() % tMax;
    const idx = Math.floor(elapsed / dt);

    const [sx, sy] = body1_positions[idx];
    const [ex, ey] = body2_positions[idx];

    // scala pozițiile după unitățile din JSON (aici 10000 doar exemplu)
    sunRef.current.position.set(sx, 0, sy);
    earthRef.current.position.set(ex, 0, ey);
  });

  if (!data) return null;

  return (
    <>
      <group ref={sunRef}>
        <SunModel />
      </group>
      <group ref={earthRef}>
        <EarthModel />
      </group>
    </>
  );
};

const SpaceScene: React.FC = () => (
  <Canvas
    camera={{ position: [0, 50, 100], fov: 45 }}
    style={{ background: "white", width: "100vw", height: "100vh" }}
  >
    <ambientLight intensity={0.2} />
    <directionalLight position={[1, 1, 1]} intensity={1} />
    <Stars radius={200} depth={50} count={5000} factor={4} fade />
    <Suspense fallback={null}>
      <TwoBodySimulation />
    </Suspense>
    <OrbitControls />
  </Canvas>
);

export default SpaceScene;
