import React, { Suspense, useRef } from "react";
import * as THREE from "three";
import { Canvas, useFrame } from "@react-three/fiber";
import { OrbitControls, Stars, useGLTF } from "@react-three/drei";

// Componentă pentru Soare
const SunModel: React.FC = () => {
  const { scene } = useGLTF("/sun.glb");
  return (
    <primitive object={scene} scale={[0.1, 0.1, 0.1]} position={[0, 0, 0]} />
  );
};

// Componentă pentru Pământ
const EarthModel: React.FC = () => {
  const { scene } = useGLTF("/earth.glb");
  return (
    <primitive object={scene} scale={[0.1, 0.11, 0.11]} position={[0, 0, 0]} />
  );
};

// Componentă pentru Lună
const MoonModel: React.FC = () => {
  const { scene } = useGLTF("/moon.glb");
  return (
    <primitive object={scene} scale={[0.1, 0.1, 0.1]} position={[0, 0, 0]} />
  );
};

const EarthAndMoonSystem: React.FC = () => {
  // Referințe pentru a urmări grupurile și lumina
  const earthOrbitRef = useRef<any>(null);
  const earthGroupRef = useRef<any>(null);
  const moonOrbitRef = useRef<any>(null);
  const moonPositionRef = useRef<any>(null);
  const moonSelfRotationRef = useRef<any>(null);
  const moonLightRef = useRef<any>(null);

  useFrame(({ clock }) => {
    const elapsed = clock.getElapsedTime();

    // Rotația Pământului în jurul Soarelui
    if (earthOrbitRef.current) {
      earthOrbitRef.current.rotation.y = elapsed * 0.1;
    }
    // Orbita Lunii în jurul Pământului
    if (moonOrbitRef.current) {
      moonOrbitRef.current.rotation.y = elapsed * 0.5;
    }
    // Rotația Lunii în jurul propriei axe
    if (moonSelfRotationRef.current) {
      moonSelfRotationRef.current.rotation.y = elapsed * 0.3;
    }

    // Actualizarea luminii lunare pentru a o face să lumineze Pământul
    if (
      moonLightRef.current &&
      moonPositionRef.current &&
      earthGroupRef.current
    ) {
      const moonWorldPos = new THREE.Vector3();
      moonPositionRef.current.getWorldPosition(moonWorldPos);

      const earthWorldPos = new THREE.Vector3();
      earthGroupRef.current.getWorldPosition(earthWorldPos);

      // Poziționează lumina exact la poziția Lunii
      moonLightRef.current.position.copy(moonWorldPos);
      // Setează target-ul luminii către centrul Pământului
      moonLightRef.current.target.position.copy(earthWorldPos);
      moonLightRef.current.target.updateMatrixWorld();
    }
  });

  return (
    <group>
      {/* Grupul care rotește Pământul în jurul Soarelui */}
      <group ref={earthOrbitRef}>
        {/* Grupul ce conține Pământul + referință pentru poziția Pământului */}
        <group ref={earthGroupRef} position={[8, 0, 0]}>
          <EarthModel />
          {/* Grupul pentru orbita Lunii */}
          <group ref={moonOrbitRef}>
            {/* Poziționare relativă a Lunii față de Pământ */}
            <group ref={moonPositionRef} position={[1, 0, 0]}>
              {/* Rotația proprie a Lunii */}
              <group ref={moonSelfRotationRef}>
                <MoonModel />
                {/* Lumina Lunii care contribuie la iluminarea Pământului */}
                <directionalLight
                  ref={moonLightRef}
                  intensity={0.5}
                  color="#ffffff"
                  castShadow
                />
              </group>
            </group>
          </group>
        </group>
      </group>
    </group>
  );
};

const SpaceScene: React.FC = () => {
  return (
    <Canvas
      camera={{ position: [0, 0, 30] }}
      style={{ background: "black", width: "100vw", height: "100vh" }}
    >
      {/* Lumina Soarelui */}
      <directionalLight position={[0.1, 0, 0]} intensity={2} castShadow />
      <directionalLight position={[-0.1, 0, 0]} intensity={2} castShadow />
      <directionalLight position={[0, 0.1, 0]} intensity={2} castShadow />
      <directionalLight position={[0, -0.1, 0]} intensity={2} castShadow />
      {/* Lumină ambientală pentru detalii */}
      <ambientLight intensity={0.3} />

      <Stars
        radius={100}
        depth={50}
        count={5000}
        factor={4}
        saturation={0}
        fade
      />

      <Suspense fallback={null}>
        <SunModel />
        <EarthAndMoonSystem />
      </Suspense>

      <OrbitControls enableZoom={true} />
    </Canvas>
  );
};

export default SpaceScene;
