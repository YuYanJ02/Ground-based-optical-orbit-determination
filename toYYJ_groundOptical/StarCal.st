stk.v.12.0
WrittenBy    STK_v12.2.0

BEGIN Star

    Name		 StarCal

    BEGIN PathDescription

        Epoch		  2.0000000000000000e+03
        RefFrame		 J2000
        RightAscension		  7.1500000000000000e+01
        Declination		 -2.0766666666666666e+01
        ProperMotionRAPerYr		  0.0000000000000000e+00
        ProperMotionDecPerYr		  0.0000000000000000e+00
        Parallax		  0.0000000000000000e+00
        RadialVelocity		  0.0000000000000000e+00

    END PathDescription

    BEGIN PhysicalData

        Magnitude		  0.0000000000000000e+00

    END PhysicalData

    BEGIN IdentityData

        Id		 0

    END IdentityData


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
            BEGIN ShortText

            END ShortText
            BEGIN LongText

            END LongText
        END Desc

        BEGIN Crdn
        END Crdn

        BEGIN Graphics

            BEGIN Attributes

                MarkerColor		 #00ff00
                LabelColor		 #00ff00
                MarkerStyle		 2
                FontStyle		 0

            END Attributes

            BEGIN Graphics

                Show		 On
                Inherit		 On
                ShowLabel		 On
                ShowMarker		 On

            END Graphics
        END Graphics

        BEGIN VO
        END VO

    END Extensions

END Star

