stk.v.12.0
WrittenBy    STK_v12.2.0

BEGIN Planet

    Name		 Vesta

    BEGIN PathDescription

        CentralBody		 Vesta
        UseCbEphemeris		 Yes

        BEGIN EphemerisData

            EphemerisSource		 None

            JplIndex		 -1

            JplSpiceId		 2000004

            ApplyTDTtoTDBCorrectionForDE		 Yes

            OrbitEpoch		  2.4551975000000009e+06
            OrbitCrdSys		 EclipticJ2000ICRF
            OrbitCrdSysEpoch		  2.4515450000000000e+06
            OrbitMeanDist		  3.5334039220481982e+11
            OrbitEcc		  8.8731055469660328e-02
            OrbitInc		  7.1344308292978029e+00
            OrbitRAAN		  1.0391484950246002e+02
            OrbitPerLong		  2.5375212975141056e+02
            OrbitMeanLong		  5.0644149521757953e+02
            OrbitMeanDistDot		  0.0000000000000000e+00
            OrbitEccDot		  0.0000000000000000e+00
            OrbitIncDot		  0.0000000000000000e+00
            OrbitRAANDot		  0.0000000000000000e+00
            OrbitPerLongDot		  0.0000000000000000e+00
            OrbitMeanLongDot		  2.7152027311295329e-01

        END EphemerisData

    END PathDescription

    BEGIN PhysicalData

        GM		  1.7288244969299999e+10
        Radius		  2.8900000000000000e+05
        Magnitude		  0.0000000000000000e+00
        ReferenceDistance		  0.0000000000000000e+00

    END PhysicalData

    BEGIN AutoRename

        AutoRename		 Yes

    END AutoRename

    BEGIN Extensions

        BEGIN ExternData
        END ExternData

        BEGIN ADFFileData
        END ADFFileData

        BEGIN AccessConstraints
            LineOfSight IncludeIntervals

            UsePreferredMaxStep No
            PreferredMaxStep 360
        END AccessConstraints

        BEGIN Desc
        END Desc

        BEGIN Crdn
        END Crdn

        BEGIN Graphics

            BEGIN Attributes

                MarkerColor		 #00ffff
                LabelColor		 #00ffff
                LineColor		 #00ffff
                LineStyle		 0
                LineWidth		 1
                MarkerStyle		 2
                FontStyle		 0

            END Attributes

            BEGIN Graphics

                Show		 Off
                Inherit		 On
                ShowLabel		 On
                ShowPlanetPoint		 On
                ShowSubPlanetPoint		 On
                ShowSubPlanetLabel		 On
                ShowOrbit		 Off
                NumOrbitPoints		 360
                OrbitTime		  1.1455498200335331e+08
                OrbitDisplay		                OneOrbit		
                TransformTrajectory		 On

            END Graphics
        END Graphics

        BEGIN VO
        END VO

    END Extensions

END Planet

