stk.v.12.0
WrittenBy    STK_v12.2.0
BEGIN Scenario
    Name		 toYYJ_Ground_Optical

    BEGIN Epoch

        Epoch		 28 Aug 2024 04:01:00.000000000
        SmartEpoch		
        BEGIN EVENT
            Epoch		 28 Aug 2024 04:01:00.000000000
            EventEpoch		
            BEGIN EVENT
                Type		 EVENT_LINKTO
                Name		 AnalysisStartTime
            END EVENT
            EpochState		 Implicit
        END EVENT


    END Epoch

    BEGIN Interval

        Start		 28 Aug 2024 04:01:00.000000000
        Stop		 28 Apr 2027 04:01:00.000000000
        SmartInterval		
        BEGIN EVENTINTERVAL
            BEGIN Interval
                Start		 28 Aug 2024 04:01:00.000000000
                Stop		 28 Apr 2027 04:01:00.000000000
            END Interval
            IntervalState		 Explicit
        END EVENTINTERVAL

        EpochUsesAnalStart		 No
        AnimStartUsesAnalStart		 Yes
        AnimStopUsesAnalStop		 Yes

    END Interval

    BEGIN EOPFile

        InheritEOPSource		 No
        EOPFilename		 EOP-v1.1.txt

    END EOPFile

    BEGIN GlobalPrefs
        SatelliteNoOrbWarning		 No
        MissilePerigeeWarning		 No
        MissileStopTimeWarning		 No
        AircraftWGS84Warning		 Always
    END GlobalPrefs

    BEGIN CentralBody

        PrimaryBody		 Earth

    END CentralBody

    BEGIN CentralBodyTerrain

        BEGIN CentralBody
            Name		 Earth
            UseTerrainCache		 Yes
            TotalCacheSize		 402653184

            BEGIN StreamingTerrain
                UseCurrentStreamingTerrainServer		 No
                StreamingTerrainServerName		 assets.agi.com/stk-terrain/
                StreamingTerrainAzimuthElevationMaskEnabled		 No
                StreamingTerrainObscurationEnabled		 No
                StreamingTerrainCoverageGridObscurationEnabled		 No
            END StreamingTerrain
        END CentralBody

    END CentralBodyTerrain

    BEGIN StarCollection

        Name		 Hipparcos 2 Collection

    END StarCollection

    BEGIN ScenarioLicenses
        Module		 AMMProv12.2
        Module		 AMMv12.2
        Module		 ASTGv12.2
        Module		 AviatorRestrictedv12.2
        Module		 CATv12.2
        Module		 CHAINSv12.2
        Module		 CONv12.2
        Module		 COVv12.2
        Module		 CRMv12.2
        Module		 Commv12.2
        Module		 DISv12.2
        Module		 EOIRv12.2
        Module		 HRMv12.2
        Module		 MexServv12.2
        Module		 RT3Clientv12.2
        Module		 RdrAdvEnv12.2
        Module		 SEETv12.2
        Module		 STKCAP
        Module		 STKExpertv12.2
        Module		 STKIntegrationv12.2
        Module		 STKParallelComputingv12.2
        Module		 STKProfessionalv12.2
        Module		 STKTandE
        Module		 STKv12.2
        Module		 SatelliteCollectionv12.2
        Module		 TERNv12.2
        Module		 TIREMv12.2
        Module		 UPropv12.2
        Module		 Underseav12.2
    END ScenarioLicenses

    BEGIN QuickReports

        BEGIN Report
            Name		 Segment Summary
            Type		 Report
            BaseDir		 Install
            Style		 Segment Summary
            AGIViewer		 Yes
            Instance		 Satellite/DROB_BillG_PostDRD
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 1
                    SectionType		 0
                    ShowIntervals		 No
                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 879
            WindowRectTop		 518
            WindowRectRight		 2528
            WindowRectBottom		 1100
        END Report

        BEGIN Report
            Name		 LLA Position
            Type		 Report
            BaseDir		 Install
            Style		 LLA Position
            AGIViewer		 Yes
            Instance		 Satellite/DROB_OEM
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 1
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"22 May 2025 16:00:00.000000000" "23 May 2025 16:00:00.000000000"
                        END Intervals

                    END IntervalList

                    TimeType		 Interval
                    SamplingType		 FixedStep
                    Step		 60
                    TimeBound		 0
                END Section
            END TimeData
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 717
            WindowRectTop		 462
            WindowRectRight		 2525
            WindowRectBottom		 1380
        END Report

        BEGIN Report
            Name		 J2000 Position Velocity
            Type		 Graph
            BaseDir		 Install
            Style		 J2000 Position Velocity
            AGIViewer		 No
            Instance		 Satellite/DROB_OEM
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 2
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"28 Aug 2024 03:59:59.999987000" "12 Aug 2025 00:00:00.000000000"
                        END Intervals

                    END IntervalList

                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 913
            WindowRectTop		 658
            WindowRectRight		 2660
            WindowRectBottom		 1564
        END Report

        BEGIN Report
            Name		 Classical Orbit Elements
            Type		 Report
            BaseDir		 Install
            Style		 Classical Orbit Elements
            AGIViewer		 Yes
            Instance		 Satellite/IBEX_BillG
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 1
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"28 Feb 2025 23:58:50.816000000" "23 Feb 2026 23:58:50.816000000"
                        END Intervals

                    END IntervalList

                    TimeType		 Interval
                    SamplingType		 FixedStep
                    Step		 86400
                    TimeBound		 0
                END Section
            END TimeData
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 917
            WindowRectTop		 335
            WindowRectRight		 2821
            WindowRectBottom		 1381
        END Report

        BEGIN Report
            Name		 Segment Summary1
            Type		 Report
            BaseDir		 Install
            Style		 Segment Summary
            AGIViewer		 Yes
            Instance		 Satellite/TD1
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 1
                    SectionType		 0
                    ShowIntervals		 No
                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 619
            WindowRectTop		 364
            WindowRectRight		 1538
            WindowRectBottom		 1400
        END Report

        BEGIN Report
            Name		 Segment Summary2
            Type		 Report
            BaseDir		 Install
            Style		 Segment Summary
            AGIViewer		 Yes
            Instance		 Satellite/TD1
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 1
                    SectionType		 0
                    ShowIntervals		 No
                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 1545
            WindowRectTop		 352
            WindowRectRight		 2464
            WindowRectBottom		 1388
        END Report

        BEGIN Report
            Name		 RIC
            Type		 Graph
            BaseDir		 Install
            Style		 RIC
            AGIViewer		 No
            Instance		 Satellite/DROA_OEM
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 2
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"28 Aug 2024 03:59:59.999987000" "14 Sep 2025 00:00:00.000000000"
                        END Intervals

                    END IntervalList

                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            BEGIN PreDataList
                BEGIN PreData
                    ServiceName		 Ric
                    Data		 Satellite/DROB_OEM
                END PreData
            END PreDataList
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 665
            WindowRectTop		 291
            WindowRectRight		 2584
            WindowRectBottom		 1530
        END Report

        BEGIN Report
            Name		 RIC1
            Type		 Graph
            BaseDir		 Install
            Style		 RIC
            AGIViewer		 No
            Instance		 Satellite/DROB_BillG_PostDRD
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 2
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"6 May 2025 23:58:50.816000000" "25 Jul 2025 23:58:50.816000000"
                        END Intervals

                    END IntervalList

                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            BEGIN PreDataList
                BEGIN PreData
                    ServiceName		 Ric
                    Data		 Satellite/DROB_OEM
                END PreData
            END PreDataList
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 766
            WindowRectTop		 511
            WindowRectRight		 2186
            WindowRectBottom		 1396
        END Report

        BEGIN Report
            Name		 RIC2
            Type		 Graph
            BaseDir		 Install
            Style		 RIC
            AGIViewer		 No
            Instance		 Satellite/DROB_BillG_PostDRD
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 2
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"6 May 2025 23:58:50.816000000" "28 Jul 2025 23:58:50.816000000"
                        END Intervals

                    END IntervalList

                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            BEGIN PreDataList
                BEGIN PreData
                    ServiceName		 Ric
                    Data		 Satellite/DROB_OEM
                END PreData
            END PreDataList
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 766
            WindowRectTop		 511
            WindowRectRight		 2305
            WindowRectBottom		 1421
        END Report

        BEGIN Report
            Name		 RIC3
            Type		 Graph
            BaseDir		 Install
            Style		 RIC
            AGIViewer		 No
            Instance		 Satellite/DROB_OEM
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 2
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"2 Jul 2025 00:00:00.000000000" "7 Jan 2026 00:00:00.000000000"
                        END Intervals

                    END IntervalList

                    TimeType		 Availability
                    SamplingType		 FixedStep
                    Step		 60
                    TimeBound		 0
                END Section
            END TimeData
            BEGIN PreDataList
                BEGIN PreData
                    ServiceName		 Ric
                    Data		 Satellite/CE6_Obs
                END PreData
            END PreDataList
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 1801
            WindowRectTop		 489
            WindowRectRight		 2980
            WindowRectBottom		 1397
        END Report

        BEGIN Report
            Name		 Classical Orbit Elements1
            Type		 Graph
            BaseDir		 Install
            Style		 Classical Orbit Elements
            AGIViewer		 No
            Instance		 Satellite/CE6_Obs
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 2
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"29 Nov 2025 23:58:50.816000000" "27 Feb 2026 23:58:50.816000000"
                        END Intervals

                    END IntervalList

                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 570
            WindowRectTop		 315
            WindowRectRight		 1749
            WindowRectBottom		 1223
        END Report

        BEGIN Report
            Name		 Segment Summary3
            Type		 Report
            BaseDir		 Install
            Style		 Segment Summary
            AGIViewer		 Yes
            Instance		 Satellite/CE6_Obs
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 1
                    SectionType		 0
                    ShowIntervals		 No
                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 619
            WindowRectTop		 364
            WindowRectRight		 2163
            WindowRectBottom		 1409
        END Report

        BEGIN Report
            Name		 Segment Summary4
            Type		 Report
            BaseDir		 Install
            Style		 Segment Summary
            AGIViewer		 Yes
            Instance		 Satellite/CE6_Obs
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 1
                    SectionType		 0
                    ShowIntervals		 No
                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 472
            WindowRectTop		 1516
            WindowRectRight		 786
            WindowRectBottom		 1587
        END Report

        BEGIN Report
            Name		 Classical Orbit Elements2
            Type		 Report
            BaseDir		 Install
            Style		 Classical Orbit Elements
            AGIViewer		 Yes
            Instance		 Satellite/CE6_Obs
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 1
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"9 Dec 2025 00:00:00.000000000" "11 Jan 2026 19:36:18.721268684"
                        END Intervals

                    END IntervalList

                    TimeType		 Interval
                    SamplingType		 FixedStep
                    Step		 3600
                    TimeBound		 0
                END Section
            END TimeData
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 472
            WindowRectTop		 987
            WindowRectRight		 786
            WindowRectBottom		 1587
        END Report

        BEGIN Report
            Name		 Classical Orbit Elements3
            Type		 Report
            BaseDir		 Install
            Style		 Classical Orbit Elements
            AGIViewer		 Yes
            Instance		 Satellite/CE6
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 1
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"9 Dec 2025 00:00:00.000000000" "12 Mar 2026 19:27:51.249066733"
                        END Intervals

                    END IntervalList

                    TimeType		 Interval
                    SamplingType		 FixedStep
                    Step		 3600
                    TimeBound		 0
                END Section
            END TimeData
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 766
            WindowRectTop		 511
            WindowRectRight		 2915
            WindowRectBottom		 1556
        END Report

        BEGIN Report
            Name		 RIC4
            Type		 Graph
            BaseDir		 Install
            Style		 RIC
            AGIViewer		 No
            Instance		 Satellite/CE6_Obs
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 2
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"6 Dec 2025 23:58:50.816000000" "12 Dec 2025 13:36:18.721000001"
                        END Intervals

                    END IntervalList

                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            BEGIN UnitData
                UseDefaultUnits		 No
                BEGIN DimUnitList
                    DistanceUnit		 Kilometers
                    SmallDistanceUnit		 Meters
                    TimeUnit		 Seconds
                    AngleUnit		 Radians
                    MassUnit		 Kilograms
                    DateFormat		 GregorianLCL
                    LatitudeUnit		 Radians
                    LongitudeUnit		 Radians
                    DurationUnit		 Seconds
                    ForceUnit		 Newtons
                    PressureUnit		 Pascals
                    SpecificImpulseUnit		 Seconds
                    PowerUnit		 Watts
                    VoltageUnit		 Volts
                    Percent		 UnitValue
                    BandwidthUnit		 Hertz
                    SpectralBandwidthUnit		 Hertz
                    BitsUnit		 Bits
                    RatioUnit		 Units
                    FrequencyUnit		 Hertz
                    SolidAngle		 Steradians
                    DopplerVelocityUnit		 MetersperSecond
                    SmallVelocityUnit		 MetersperSecond
                    SmallTimeUnit		 Seconds
                    RcsUnit		 SquareMeters
                    SARTimeResProdUnit		 Meter-Second
                    PRFUnit		 Hertz
                    MagneticFieldUnit		 Tesla
                    Temperature		 Kelvin
                    AviatorDistanceUnit		 Meters
                    AviatorTimeUnit		 Seconds
                    AviatorAltTimeUnit		 Seconds
                    AviatorSmallTimeUnit		 Seconds
                    AviatorAltitudeUnit		 Meters
                    AviatorFuelQuantityUnit		 Kilograms
                    AviatorRunwayLengthUnit		 Meters
                    AviatorBearingAngleUnit		 Radians
                    AviatorAngleOfAttackUnit		 Radians
                    AviatorAttitudeAngleUnit		 Radians
                    AviatorGUnit		 StandardSeaLevelG
                    AviatorTSFCUnit		 TSFCKgSecN
                    AviatorPSFCUnit		 PSFCKgSecW
                    AviatorForceUnit		 Newtons
                    AviatorPowerUnit		 FlightWatt
                    AviatorEnergyUnit		 watt-seconds
                    RadiationDose		 Rads
                    RadiationShieldThickness		 Meters
                    ParticleEnergy		 MeV
                END DimUnitList
            END UnitData
            BEGIN PreDataList
                BEGIN PreData
                    ServiceName		 Ric
                    Data		 Satellite/CE6
                END PreData
            END PreDataList
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 837
            WindowRectTop		 570
            WindowRectRight		 2766
            WindowRectBottom		 1562
        END Report

        BEGIN Report
            Name		 RIC5
            Type		 Graph
            BaseDir		 Install
            Style		 RIC
            AGIViewer		 No
            Instance		 Satellite/CE6_Obs
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 2
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"7 Nov 2025 23:58:50.816000000" "11 Jan 2026 19:28:19.913449287"
                        END Intervals

                    END IntervalList

                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            BEGIN PreDataList
                BEGIN PreData
                    ServiceName		 Ric
                    Data		 Satellite/CE6
                END PreData
            END PreDataList
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 570
            WindowRectTop		 315
            WindowRectRight		 2046
            WindowRectBottom		 1307
        END Report

        BEGIN Report
            Name		 RIC6
            Type		 Graph
            BaseDir		 Install
            Style		 RIC
            AGIViewer		 No
            Instance		 Satellite/DROA_Obs
            BEGIN TimeData
                BEGIN Section
                    SectionNumber		 2
                    SectionType		 2
                    ShowIntervals		 No
                    BEGIN IntervalList

                        DateUnitAbrv		 UTCG

                        BEGIN Intervals

"18 Sep 2024 23:58:50.816000000" "4 Feb 2026 23:58:50.816000000"
                        END Intervals

                    END IntervalList

                    TimeType		 Availability
                    SamplingType		 Default
                    TimeBound		 0
                END Section
            END TimeData
            BEGIN PreDataList
                BEGIN PreData
                    ServiceName		 Ric
                    Data		 Satellite/DROA_OEM
                END PreData
            END PreDataList
            DisplayOnLoad		 No
            FrameType		 0
            DockCircleID		 0
            DockID		 0
            WindowRectLeft		 570
            WindowRectTop		 315
            WindowRectRight		 2303
            WindowRectBottom		 1509
        END Report
    END QuickReports

    BEGIN Extensions

        BEGIN ClsApp
            RangeConstraint		 5000
            ApoPeriPad		 30000
            OrbitPathPad		 100000
            TimeDistPad		 30000
            OutOfDate		 2592000
            MaxApoPeriStep		 900
            ApoPeriAngle		 0.7853981633974483
            UseApogeePerigeeFilter		 Yes
            UsePathFilter		 No
            UseTimeFilter		 No
            UseOutOfDate		 Yes
            CreateSats		 No
            MaxSatsToCreate		 500
            UseModelScale		 No
            ModelScale		 0
            UseCrossRefDb		 Yes
            CollisionDB		 stkAllTLE.tce
            CollisionCrossRefDB		 stkAllTLE.sd
            ShowLine		 Yes
            AnimHighlight		 Yes
            StaticHighlight		 Yes
            UseLaunchWindow		 No
            LaunchWindowUseEntireTraj		 Yes
            LaunchWindowTrajMETStart		 0
            LaunchWindowTrajMETStop		 900
            LaunchWindowStart		 604740
            LaunchWindowStop		 -83376060
            LaunchMETOffset		 0
            LaunchWindowUseSecEphem		 No 
            LaunchWindowUseScenFolderForSecEphem		 Yes
            LaunchWindowUsePrimEphem		 No 
            LaunchWindowUseScenFolderForPrimEphem		 Yes
            LaunchWindowIntervalPtr		
            BEGIN EVENTINTERVAL
                BEGIN Interval
                    Start		 4 Sep 2024 04:00:00.000000000
                    Stop		 5 Sep 2024 04:00:00.000000000
                END Interval
                IntervalState		 Explicit
            END EVENTINTERVAL

            LaunchWindowUsePrimMTO		 No 
            GroupLaunches		 No 
            LWTimeConvergence		 0.001
            LWRelValueConvergence		 1e-08
            LWTSRTimeConvergence		 0.0001
            LWTSRRelValueConvergence		 1e-10
            LaunchWindowStep		 300
            MaxTSRStep		  1.8000000000000000e+02
            MaxTSRRelMotion		  2.0000000000000000e+01
            UseLaunchArea		 No 
            LaunchAreaOrientation		 North
            LaunchAreaAzimuth		 0
            LaunchAreaXLimits		 -10000 10000
            LaunchAreaYLimits		 -10000 10000
            LaunchAreaNumXIntrPnts		 1
            LaunchAreaNumYIntrPnts		 1
            LaunchAreaAltReference		 Ellipsoid
            TargetSameStop		 No 
            SkipSurfaceMetric		 No 
            LWAreaTSRRelValueConvergence		 1e-10
            AreaLaunchWindowStep		 300
            AreaMaxTSRStep		  3.0000000000000000e+01
            AreaMaxTSRRelMotion		 1
            ShowLaunchArea		 No 
            ShowBlackoutTracks		 No 
            ShowClearedTracks		 No 
            UseObjectForClearedColor		 No 
            BlackoutColor		 #ff0000
            ClearedColor		 #ffffff
            ShowTracksSegments		 No 
            ShowMinRangeTracks		 No 
            MinRangeTrackTimeStep		 0.5
            UsePrimStepForTracks		 Yes
            GfxTracksTimeStep		 30
            GfxAreaNumXIntrPnts		 1
            GfxAreaNumYIntrPnts		 1
            CreateLaunchMTO		 No 
            CovarianceSigmaScale		 3
            CovarianceMode		 None 
        END ClsApp

        BEGIN Units
            DistanceUnit		 Kilometers
            TimeUnit		 Seconds
            DateFormat		 GregorianLCL
            AngleUnit		 Degrees
            MassUnit		 Kilograms
            PowerUnit		 dBW
            FrequencyUnit		 Gigahertz
            SmallDistanceUnit		 Meters
            LatitudeUnit		 Degrees
            LongitudeUnit		 Degrees
            DurationUnit		 Hr:Min:Sec
            Temperature		 Kelvin
            SmallTimeUnit		 Seconds
            RatioUnit		 Decibel
            RcsUnit		 Decibel
            DopplerVelocityUnit		 MetersperSecond
            SARTimeResProdUnit		 Meter-Second
            ForceUnit		 Newtons
            PressureUnit		 Pascals
            SpecificImpulseUnit		 Seconds
            PRFUnit		 Kilohertz
            BandwidthUnit		 Megahertz
            SmallVelocityUnit		 CentimetersperSecond
            Percent		 Percentage
            AviatorDistanceUnit		 NauticalMiles
            AviatorTimeUnit		 Hours
            AviatorAltitudeUnit		 Feet
            AviatorFuelQuantityUnit		 Pounds
            AviatorRunwayLengthUnit		 Kilofeet
            AviatorBearingAngleUnit		 Degrees
            AviatorAngleOfAttackUnit		 Degrees
            AviatorAttitudeAngleUnit		 Degrees
            AviatorGUnit		 StandardSeaLevelG
            SolidAngle		 Steradians
            AviatorTSFCUnit		 TSFCLbmHrLbf
            AviatorPSFCUnit		 PSFCLbmHrHp
            AviatorForceUnit		 Pounds
            AviatorPowerUnit		 Horsepower
            SpectralBandwidthUnit		 Hertz
            AviatorAltTimeUnit		 Minutes
            AviatorSmallTimeUnit		 Seconds
            AviatorEnergyUnit		 kilowatt-hours
            BitsUnit		 MegaBits
            RadiationDose		 Rads
            MagneticFieldUnit		 nanoTesla
            VoltageUnit		 Volts
            RadiationShieldThickness		 Mils
            ParticleEnergy		 MeV
        END Units

        BEGIN ReportUnits
            DistanceUnit		 Kilometers
            TimeUnit		 Seconds
            DateFormat		 GregorianUTC
            AngleUnit		 Degrees
            MassUnit		 Kilograms
            PowerUnit		 dBW
            FrequencyUnit		 Gigahertz
            SmallDistanceUnit		 Meters
            LatitudeUnit		 Degrees
            LongitudeUnit		 Degrees
            DurationUnit		 Hr:Min:Sec
            Temperature		 Kelvin
            SmallTimeUnit		 Seconds
            RatioUnit		 Decibel
            RcsUnit		 Decibel
            DopplerVelocityUnit		 MetersperSecond
            SARTimeResProdUnit		 Meter-Second
            ForceUnit		 Newtons
            PressureUnit		 Pascals
            SpecificImpulseUnit		 Seconds
            PRFUnit		 Kilohertz
            BandwidthUnit		 Megahertz
            SmallVelocityUnit		 CentimetersperSecond
            Percent		 Percentage
            AviatorDistanceUnit		 NauticalMiles
            AviatorTimeUnit		 Hours
            AviatorAltitudeUnit		 Feet
            AviatorFuelQuantityUnit		 Pounds
            AviatorRunwayLengthUnit		 Kilofeet
            AviatorBearingAngleUnit		 Degrees
            AviatorAngleOfAttackUnit		 Degrees
            AviatorAttitudeAngleUnit		 Degrees
            AviatorGUnit		 StandardSeaLevelG
            SolidAngle		 Steradians
            AviatorTSFCUnit		 TSFCLbmHrLbf
            AviatorPSFCUnit		 PSFCLbmHrHp
            AviatorForceUnit		 Pounds
            AviatorPowerUnit		 Horsepower
            SpectralBandwidthUnit		 Hertz
            AviatorAltTimeUnit		 Minutes
            AviatorSmallTimeUnit		 Seconds
            AviatorEnergyUnit		 kilowatt-hours
            BitsUnit		 MegaBits
            RadiationDose		 Rads
            MagneticFieldUnit		 nanoTesla
            VoltageUnit		 Volts
            RadiationShieldThickness		 Mils
            ParticleEnergy		 MeV
        END ReportUnits

        BEGIN ConnectReportUnits
            DistanceUnit		 Kilometers
            TimeUnit		 Seconds
            DateFormat		 GregorianUTC
            AngleUnit		 Degrees
            MassUnit		 Kilograms
            PowerUnit		 dBW
            FrequencyUnit		 Gigahertz
            SmallDistanceUnit		 Meters
            LatitudeUnit		 Degrees
            LongitudeUnit		 Degrees
            DurationUnit		 Hr:Min:Sec
            Temperature		 Kelvin
            SmallTimeUnit		 Seconds
            RatioUnit		 Decibel
            RcsUnit		 Decibel
            DopplerVelocityUnit		 MetersperSecond
            SARTimeResProdUnit		 Meter-Second
            ForceUnit		 Newtons
            PressureUnit		 Pascals
            SpecificImpulseUnit		 Seconds
            PRFUnit		 Kilohertz
            BandwidthUnit		 Megahertz
            SmallVelocityUnit		 CentimetersperSecond
            Percent		 Percentage
            AviatorDistanceUnit		 NauticalMiles
            AviatorTimeUnit		 Hours
            AviatorAltitudeUnit		 Feet
            AviatorFuelQuantityUnit		 Pounds
            AviatorRunwayLengthUnit		 Kilofeet
            AviatorBearingAngleUnit		 Degrees
            AviatorAngleOfAttackUnit		 Degrees
            AviatorAttitudeAngleUnit		 Degrees
            AviatorGUnit		 StandardSeaLevelG
            SolidAngle		 Steradians
            AviatorTSFCUnit		 TSFCLbmHrLbf
            AviatorPSFCUnit		 PSFCLbmHrHp
            AviatorForceUnit		 Pounds
            AviatorPowerUnit		 Horsepower
            SpectralBandwidthUnit		 Hertz
            AviatorAltTimeUnit		 Minutes
            AviatorSmallTimeUnit		 Seconds
            AviatorEnergyUnit		 kilowatt-hours
            BitsUnit		 MegaBits
            RadiationDose		 Rads
            MagneticFieldUnit		 nanoTesla
            VoltageUnit		 Volts
            RadiationShieldThickness		 Mils
            ParticleEnergy		 MeV
        END ConnectReportUnits

        BEGIN ReportFavorites
            BEGIN Class
                Name		 Satellite
                BEGIN Favorite
                    Type		 Report
                    BaseDir		 Install
                    Style		 J2000 Position Velocity
                END Favorite
                BEGIN Favorite
                    Type		 Report
                    BaseDir		 Install
                    Style		 Attitude Quaternions
                END Favorite
                BEGIN Favorite
                    Type		 Report
                    BaseDir		 Install
                    Style		 RIC
                END Favorite
                BEGIN Favorite
                    Type		 Report
                    BaseDir		 Install
                    Style		 Inertial Position Velocity
                END Favorite
                BEGIN Favorite
                    Type		 Graph
                    BaseDir		 Install
                    Style		 J2000 Position Velocity
                END Favorite
                BEGIN Favorite
                    Type		 Report
                    BaseDir		 Install
                    Style		 LLA Position
                END Favorite
                BEGIN Favorite
                    Type		 Graph
                    BaseDir		 Install
                    Style		 Solar Elevation - Body Fixed
                END Favorite
                BEGIN Favorite
                    Type		 Report
                    BaseDir		 Install
                    Style		 Sun
                END Favorite
                BEGIN Favorite
                    Type		 Report
                    BaseDir		 Install
                    Style		 Classical Orbit Elements
                END Favorite
                BEGIN Favorite
                    Type		 Graph
                    BaseDir		 Install
                    Style		 RIC
                END Favorite
                BEGIN Favorite
                    Type		 Graph
                    BaseDir		 Install
                    Style		 Classical Orbit Elements
                END Favorite
            END Class
            BEGIN Class
                Name		 Sensor
                BEGIN Favorite
                    Type		 Report
                    BaseDir		 Install
                    Style		 Boresight Vector
                END Favorite
            END Class
        END ReportFavorites

        BEGIN ADFFileData
        END ADFFileData

        BEGIN GenDb

            BEGIN Database
                DbType		 Satellite
                DefDb		 stkAllTLE.sd
                UseMyDb		 Off
                MaxMatches		 2000
                Use4SOC		 On

                BEGIN FieldDefaults

                    BEGIN Field
                        Name		 "SSC Number"
                        Default		 "*"
                    END Field

                    BEGIN Field
                        Name		 "Common Name"
                        Default		 "*"
                    END Field

                END FieldDefaults

            END Database

            BEGIN Database
                DbType		 City
                DefDb		 stkCityDb.cd
                UseMyDb		 Off
                MaxMatches		 2000
                Use4SOC		 On

                BEGIN FieldDefaults

                    BEGIN Field
                        Name		 "City Name"
                        Default		 "*"
                    END Field

                END FieldDefaults

            END Database

            BEGIN Database
                DbType		 Facility
                DefDb		 stkFacility.fd
                UseMyDb		 Off
                MaxMatches		 2000
                Use4SOC		 On

                BEGIN FieldDefaults

                END FieldDefaults

            END Database
        END GenDb

        BEGIN SOCDb
            BEGIN Defaults
                BEGIN Catalog Cities
                    BEGIN Criteria Name
                        Type		 Value
                        Value		 miyun
                    END Criteria
                END Catalog
            END Defaults
        END SOCDb

        BEGIN Msgp4Ext
        END Msgp4Ext

        BEGIN FileLocations
        END FileLocations

        BEGIN Author
            Optimize		 No
            UseBasicGlobe		 No
            SaveEphemeris		 Yes
            SaveScenFolder		 No
            BEGIN ExternalFileTypes
                BEGIN Type
                    FileType		 Calculation Scalar
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 Celestial Image
                    Include		 No
                END Type
                BEGIN Type
                    FileType		 Cloud
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 EOP
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 External Vector Data
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 Globe
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 Globe Data
                    Include		 No
                END Type
                BEGIN Type
                    FileType		 Map
                    Include		 No
                END Type
                BEGIN Type
                    FileType		 Map Image
                    Include		 No
                END Type
                BEGIN Type
                    FileType		 Marker/Label
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 Model
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 Object Break-up File
                    Include		 No
                END Type
                BEGIN Type
                    FileType		 Planetary Ephemeris
                    Include		 No
                END Type
                BEGIN Type
                    FileType		 Report Style Script
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 Report/Graph Style
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 Scalar Calculation File
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 Terrain
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 Volume Grid Intervals File
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 Volumetric File
                    Include		 Yes
                END Type
                BEGIN Type
                    FileType		 WTM
                    Include		 Yes
                END Type
            END ExternalFileTypes
            ReadOnly		 No
            ViewerPassword		 No
            STKPassword		 No
            ExcludeInstallFiles		 No
            BEGIN ExternalFileList
            END ExternalFileList
        END Author

        BEGIN ExportDataFile
            FileType		 Ephemeris
            Directory		 E:\DRO\in_orbit\in_Orbit_Scn\droGroundOptical
            IntervalType		 User
            TimePeriodStart		 40683540
            TimePeriodStop		 40726740
            StepType		 User
            StepSize		 60
            EphemType		 STK
            UseVehicleCentralBody		 Yes
            CentralBody		 Earth
            SatelliteID		 -200000
            CoordSys		 ICRF
            NonSatCoordSys		 Fixed
            InterpolateBoundaries		 Yes
            EphemFormat		 Current
            InterpType		 9
            InterpOrder		 5
            AttCoordSys		 Fixed
            Quaternions		 0
            ExportCovar		 Position
            AttitudeFormat		 Current
            TimePrecision		 6
            CCSDSDateFormat		 YMD
            CCSDSEphFormat		 SciNotation
            CCSDSTimeSystem		 UTC
            CCSDSRefFrame		 ICRF
            CCSDSOriginator		 CASCSU
            UseSatCenterAndFrame		 No
            IncludeCovariance		 No
            IncludeAcceleration		 No
            CCSDSFileFormat		 KVN
        END ExportDataFile

        BEGIN Desc
        END Desc

        BEGIN RfEnv
<?xml version = "1.0" standalone = "yes"?>
<SCOPE>
    <VAR name = "PropagationChannel">
        <SCOPE>
            <VAR name = "UseITU618Section2p5">
                <BOOL>false</BOOL>
            </VAR>
            <VAR name = "UseCloudFogModel">
                <BOOL>false</BOOL>
            </VAR>
            <VAR name = "CloudFogModel">
                <SCOPE Class = "LinkEmbedControl">
                    <VAR name = "ReferenceType">
                        <STRING>&quot;Unlinked&quot;</STRING>
                    </VAR>
                    <VAR name = "Component">
                        <VAR name = "ITU-R_P840-7">
                            <SCOPE Class = "CloudFogLossModel">
                                <VAR name = "Version">
                                    <STRING>&quot;1.0.0 a&quot;</STRING>
                                </VAR>
                                <VAR name = "IdentifierInformation">
                                    <SCOPE>
                                        <VAR name = "Identifier">
                                            <STRING>&quot;{F602B69C-1CCA-4514-A871-79A7D4DE7796}&quot;</STRING>
                                        </VAR>
                                        <VAR name = "Version">
                                            <STRING>&quot;1&quot;</STRING>
                                        </VAR>
                                        <VAR name = "SourceIdentifierInformation">
                                            <SCOPE>
                                                <VAR name = "Identifier">
                                                    <STRING>&quot;{E7BA4392-37BE-4446-A5C7-6068165B166A}&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Version">
                                                    <STRING>&quot;1&quot;</STRING>
                                                </VAR>
                                                <VAR name = "SdfInformation">
                                                    <SCOPE Class = "SCOPE">
                                                        <VAR name = "Version">
                                                            <STRING>&quot;0.0&quot;</STRING>
                                                        </VAR>
                                                        <VAR name = "Url">
                                                            <STRING>&quot;&quot;</STRING>
                                                        </VAR>
                                                    </SCOPE>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                        <VAR name = "SdfInformation">
                                            <SCOPE Class = "SCOPE">
                                                <VAR name = "Version">
                                                    <STRING>&quot;0.0&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Url">
                                                    <STRING>&quot;&quot;</STRING>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                    </SCOPE>
                                </VAR>
                                <VAR name = "ComponentName">
                                    <STRING>&quot;ITU-R_P840-7&quot;</STRING>
                                </VAR>
                                <VAR name = "Description">
                                    <STRING>&quot;ITU-R P840-7&quot;</STRING>
                                </VAR>
                                <VAR name = "Type">
                                    <STRING>&quot;ITU-R P840-7&quot;</STRING>
                                </VAR>
                                <VAR name = "UserComment">
                                    <STRING>&quot;ITU-R P840-7&quot;</STRING>
                                </VAR>
                                <VAR name = "ReadOnly">
                                    <BOOL>false</BOOL>
                                </VAR>
                                <VAR name = "Clonable">
                                    <BOOL>true</BOOL>
                                </VAR>
                                <VAR name = "Category">
                                    <STRING>&quot;@Top&quot;</STRING>
                                </VAR>
                                <VAR name = "LiquidWaterDensityValueChoice">
                                    <STRING>&quot;Liquid Water Content Density Value&quot;</STRING>
                                </VAR>
                                <VAR name = "CloudCeiling">
                                    <QUANTITY Dimension = "DistanceUnit" Unit = "m">
                                        <REAL>3000</REAL>
                                    </QUANTITY>
                                </VAR>
                                <VAR name = "CloudLayerThickness">
                                    <QUANTITY Dimension = "DistanceUnit" Unit = "m">
                                        <REAL>500</REAL>
                                    </QUANTITY>
                                </VAR>
                                <VAR name = "CloudTemp">
                                    <QUANTITY Dimension = "Temperature" Unit = "K">
                                        <REAL>273.15</REAL>
                                    </QUANTITY>
                                </VAR>
                                <VAR name = "CloudLiqWaterDensity">
                                    <QUANTITY Dimension = "SmallDensity" Unit = "kg*m^-3">
                                        <REAL>0.0001</REAL>
                                    </QUANTITY>
                                </VAR>
                                <VAR name = "AnnualAveragePercentValue">
                                    <QUANTITY Dimension = "Percent" Unit = "unitValue">
                                        <REAL>0.01</REAL>
                                    </QUANTITY>
                                </VAR>
                                <VAR name = "MonthlyAveragePercentValue">
                                    <QUANTITY Dimension = "Percent" Unit = "unitValue">
                                        <REAL>0.01</REAL>
                                    </QUANTITY>
                                </VAR>
                                <VAR name = "LiqWaterAverageDataMonth">
                                    <INT>1</INT>
                                </VAR>
                                <VAR name = "UseRainHeightAsCloudThickness">
                                    <BOOL>false</BOOL>
                                </VAR>
                            </SCOPE>
                        </VAR>
                    </VAR>
                </SCOPE>
            </VAR>
            <VAR name = "UseTropoScintModel">
                <BOOL>false</BOOL>
            </VAR>
            <VAR name = "TropoScintModel">
                <SCOPE Class = "LinkEmbedControl">
                    <VAR name = "ReferenceType">
                        <STRING>&quot;Unlinked&quot;</STRING>
                    </VAR>
                    <VAR name = "Component">
                        <VAR name = "ITU-R_P618-12">
                            <SCOPE Class = "TropoScintLossModel">
                                <VAR name = "Version">
                                    <STRING>&quot;1.0.0 a&quot;</STRING>
                                </VAR>
                                <VAR name = "IdentifierInformation">
                                    <SCOPE>
                                        <VAR name = "Identifier">
                                            <STRING>&quot;{435BA5B9-6E59-4998-8445-0F3A26862491}&quot;</STRING>
                                        </VAR>
                                        <VAR name = "Version">
                                            <STRING>&quot;1&quot;</STRING>
                                        </VAR>
                                        <VAR name = "SourceIdentifierInformation">
                                            <SCOPE>
                                                <VAR name = "Identifier">
                                                    <STRING>&quot;{BC27045B-5A54-458E-BF17-702BCFE40CA8}&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Version">
                                                    <STRING>&quot;1&quot;</STRING>
                                                </VAR>
                                                <VAR name = "SdfInformation">
                                                    <SCOPE Class = "SCOPE">
                                                        <VAR name = "Version">
                                                            <STRING>&quot;0.0&quot;</STRING>
                                                        </VAR>
                                                        <VAR name = "Url">
                                                            <STRING>&quot;&quot;</STRING>
                                                        </VAR>
                                                    </SCOPE>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                        <VAR name = "SdfInformation">
                                            <SCOPE Class = "SCOPE">
                                                <VAR name = "Version">
                                                    <STRING>&quot;0.0&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Url">
                                                    <STRING>&quot;&quot;</STRING>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                    </SCOPE>
                                </VAR>
                                <VAR name = "ComponentName">
                                    <STRING>&quot;ITU-R_P618-12&quot;</STRING>
                                </VAR>
                                <VAR name = "Description">
                                    <STRING>&quot;ITU-R P618-12&quot;</STRING>
                                </VAR>
                                <VAR name = "Type">
                                    <STRING>&quot;ITU-R P618-12&quot;</STRING>
                                </VAR>
                                <VAR name = "UserComment">
                                    <STRING>&quot;ITU-R P618-12&quot;</STRING>
                                </VAR>
                                <VAR name = "ReadOnly">
                                    <BOOL>false</BOOL>
                                </VAR>
                                <VAR name = "Clonable">
                                    <BOOL>true</BOOL>
                                </VAR>
                                <VAR name = "Category">
                                    <STRING>&quot;@Top&quot;</STRING>
                                </VAR>
                                <VAR name = "FadeDepthAverageTimeChoice">
                                    <STRING>&quot;Fade depth for the average year&quot;</STRING>
                                </VAR>
                                <VAR name = "ComputeDeepFade">
                                    <BOOL>false</BOOL>
                                </VAR>
                                <VAR name = "FadeOutage">
                                    <QUANTITY Dimension = "Percent" Unit = "unitValue">
                                        <REAL>0.001</REAL>
                                    </QUANTITY>
                                </VAR>
                                <VAR name = "PercentTimeRefracGrad">
                                    <QUANTITY Dimension = "Percent" Unit = "unitValue">
                                        <REAL>0.1</REAL>
                                    </QUANTITY>
                                </VAR>
                                <VAR name = "SurfaceTemperature">
                                    <QUANTITY Dimension = "Temperature" Unit = "K">
                                        <REAL>273.15</REAL>
                                    </QUANTITY>
                                </VAR>
                            </SCOPE>
                        </VAR>
                    </VAR>
                </SCOPE>
            </VAR>
            <VAR name = "UseIonoFadingModel">
                <BOOL>false</BOOL>
            </VAR>
            <VAR name = "IonoFadingModel">
                <SCOPE Class = "LinkEmbedControl">
                    <VAR name = "ReferenceType">
                        <STRING>&quot;Unlinked&quot;</STRING>
                    </VAR>
                    <VAR name = "Component">
                        <VAR name = "ITU-R_P531-13">
                            <SCOPE Class = "IonoFadingLossModel">
                                <VAR name = "Version">
                                    <STRING>&quot;1.0.0 a&quot;</STRING>
                                </VAR>
                                <VAR name = "IdentifierInformation">
                                    <SCOPE>
                                        <VAR name = "Identifier">
                                            <STRING>&quot;{C7BB182A-0C38-4E38-88E3-F1EA40519E72}&quot;</STRING>
                                        </VAR>
                                        <VAR name = "Version">
                                            <STRING>&quot;1&quot;</STRING>
                                        </VAR>
                                        <VAR name = "SourceIdentifierInformation">
                                            <SCOPE>
                                                <VAR name = "Identifier">
                                                    <STRING>&quot;{1699891E-9828-41C7-ADD4-4BE20EFC34A8}&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Version">
                                                    <STRING>&quot;1&quot;</STRING>
                                                </VAR>
                                                <VAR name = "SdfInformation">
                                                    <SCOPE Class = "SCOPE">
                                                        <VAR name = "Version">
                                                            <STRING>&quot;0.0&quot;</STRING>
                                                        </VAR>
                                                        <VAR name = "Url">
                                                            <STRING>&quot;&quot;</STRING>
                                                        </VAR>
                                                    </SCOPE>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                        <VAR name = "SdfInformation">
                                            <SCOPE Class = "SCOPE">
                                                <VAR name = "Version">
                                                    <STRING>&quot;0.0&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Url">
                                                    <STRING>&quot;&quot;</STRING>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                    </SCOPE>
                                </VAR>
                                <VAR name = "ComponentName">
                                    <STRING>&quot;ITU-R_P531-13&quot;</STRING>
                                </VAR>
                                <VAR name = "Description">
                                    <STRING>&quot;ITU-R P531-13&quot;</STRING>
                                </VAR>
                                <VAR name = "Type">
                                    <STRING>&quot;ITU-R P531-13&quot;</STRING>
                                </VAR>
                                <VAR name = "UserComment">
                                    <STRING>&quot;ITU-R P531-13&quot;</STRING>
                                </VAR>
                                <VAR name = "ReadOnly">
                                    <BOOL>false</BOOL>
                                </VAR>
                                <VAR name = "Clonable">
                                    <BOOL>true</BOOL>
                                </VAR>
                                <VAR name = "Category">
                                    <STRING>&quot;@Top&quot;</STRING>
                                </VAR>
                                <VAR name = "UseAlternateAPFile">
                                    <BOOL>false</BOOL>
                                </VAR>
                                <VAR name = "AlternateAPDataFile">
                                    <STRING>
                                        <PROP name = "FullName">
                                            <STRING>&quot;&quot;</STRING>
                                        </PROP>&quot;&quot;</STRING>
                                </VAR>
                            </SCOPE>
                        </VAR>
                    </VAR>
                </SCOPE>
            </VAR>
            <VAR name = "UseRainModel">
                <BOOL>false</BOOL>
            </VAR>
            <VAR name = "RainModel">
                <SCOPE Class = "LinkEmbedControl">
                    <VAR name = "ReferenceType">
                        <STRING>&quot;Unlinked&quot;</STRING>
                    </VAR>
                    <VAR name = "Component">
                        <VAR name = "ITU-R_P618-12">
                            <SCOPE Class = "RainLossModel">
                                <VAR name = "Version">
                                    <STRING>&quot;1.0.0 a&quot;</STRING>
                                </VAR>
                                <VAR name = "IdentifierInformation">
                                    <SCOPE>
                                        <VAR name = "Identifier">
                                            <STRING>&quot;{D2172583-67B0-4747-807D-DA64AA9AEBA2}&quot;</STRING>
                                        </VAR>
                                        <VAR name = "Version">
                                            <STRING>&quot;1&quot;</STRING>
                                        </VAR>
                                        <VAR name = "SourceIdentifierInformation">
                                            <SCOPE>
                                                <VAR name = "Identifier">
                                                    <STRING>&quot;{1113D770-D1E5-4DEF-99A3-6B3F4D5CE16A}&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Version">
                                                    <STRING>&quot;1&quot;</STRING>
                                                </VAR>
                                                <VAR name = "SdfInformation">
                                                    <SCOPE Class = "SCOPE">
                                                        <VAR name = "Version">
                                                            <STRING>&quot;0.0&quot;</STRING>
                                                        </VAR>
                                                        <VAR name = "Url">
                                                            <STRING>&quot;&quot;</STRING>
                                                        </VAR>
                                                    </SCOPE>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                        <VAR name = "SdfInformation">
                                            <SCOPE Class = "SCOPE">
                                                <VAR name = "Version">
                                                    <STRING>&quot;0.0&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Url">
                                                    <STRING>&quot;&quot;</STRING>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                    </SCOPE>
                                </VAR>
                                <VAR name = "ComponentName">
                                    <STRING>&quot;ITU-R_P618-12&quot;</STRING>
                                </VAR>
                                <VAR name = "Description">
                                    <STRING>&quot;ITU-R P618-12 rain model&quot;</STRING>
                                </VAR>
                                <VAR name = "Type">
                                    <STRING>&quot;ITU-R P618-12&quot;</STRING>
                                </VAR>
                                <VAR name = "UserComment">
                                    <STRING>&quot;ITU-R P618-12 rain model&quot;</STRING>
                                </VAR>
                                <VAR name = "ReadOnly">
                                    <BOOL>false</BOOL>
                                </VAR>
                                <VAR name = "Clonable">
                                    <BOOL>true</BOOL>
                                </VAR>
                                <VAR name = "Category">
                                    <STRING>&quot;@Top&quot;</STRING>
                                </VAR>
                                <VAR name = "SurfaceTemperature">
                                    <QUANTITY Dimension = "Temperature" Unit = "K">
                                        <REAL>273.15</REAL>
                                    </QUANTITY>
                                </VAR>
                                <VAR name = "EnableDepolarizationLoss">
                                    <BOOL>false</BOOL>
                                </VAR>
                            </SCOPE>
                        </VAR>
                    </VAR>
                </SCOPE>
            </VAR>
            <VAR name = "UseAtmosAbsorptionModel">
                <BOOL>false</BOOL>
            </VAR>
            <VAR name = "AtmosAbsorptionModel">
                <SCOPE Class = "LinkEmbedControl">
                    <VAR name = "ReferenceType">
                        <STRING>&quot;Unlinked&quot;</STRING>
                    </VAR>
                    <VAR name = "Component">
                        <VAR name = "ITU-R_P676-9">
                            <SCOPE Class = "AtmosphericAbsorptionModel">
                                <VAR name = "Version">
                                    <STRING>&quot;1.0.1 a&quot;</STRING>
                                </VAR>
                                <VAR name = "IdentifierInformation">
                                    <SCOPE>
                                        <VAR name = "Identifier">
                                            <STRING>&quot;{4E524DA2-9668-456C-A370-B8B0F04B3B8E}&quot;</STRING>
                                        </VAR>
                                        <VAR name = "Version">
                                            <STRING>&quot;1&quot;</STRING>
                                        </VAR>
                                        <VAR name = "SourceIdentifierInformation">
                                            <SCOPE>
                                                <VAR name = "Identifier">
                                                    <STRING>&quot;{5DBDF434-D4CA-44F6-8097-A6EBF681200D}&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Version">
                                                    <STRING>&quot;1&quot;</STRING>
                                                </VAR>
                                                <VAR name = "SdfInformation">
                                                    <SCOPE Class = "SCOPE">
                                                        <VAR name = "Version">
                                                            <STRING>&quot;0.0&quot;</STRING>
                                                        </VAR>
                                                        <VAR name = "Url">
                                                            <STRING>&quot;&quot;</STRING>
                                                        </VAR>
                                                    </SCOPE>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                        <VAR name = "SdfInformation">
                                            <SCOPE Class = "SCOPE">
                                                <VAR name = "Version">
                                                    <STRING>&quot;0.0&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Url">
                                                    <STRING>&quot;&quot;</STRING>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                    </SCOPE>
                                </VAR>
                                <VAR name = "ComponentName">
                                    <STRING>&quot;ITU-R_P676-9&quot;</STRING>
                                </VAR>
                                <VAR name = "Description">
                                    <STRING>&quot;ITU-R P676-9 gaseous absorption model&quot;</STRING>
                                </VAR>
                                <VAR name = "Type">
                                    <STRING>&quot;ITU-R P676-9&quot;</STRING>
                                </VAR>
                                <VAR name = "UserComment">
                                    <STRING>&quot;ITU-R P676-9 gaseous absorption model&quot;</STRING>
                                </VAR>
                                <VAR name = "ReadOnly">
                                    <BOOL>false</BOOL>
                                </VAR>
                                <VAR name = "Clonable">
                                    <BOOL>true</BOOL>
                                </VAR>
                                <VAR name = "Category">
                                    <STRING>&quot;@Top&quot;</STRING>
                                </VAR>
                                <VAR name = "UseApproxMethod">
                                    <BOOL>true</BOOL>
                                </VAR>
                                <VAR name = "UseSeasonalRegional">
                                    <BOOL>true</BOOL>
                                </VAR>
                            </SCOPE>
                        </VAR>
                    </VAR>
                </SCOPE>
            </VAR>
            <VAR name = "UseUrbanTerresPropLossModel">
                <BOOL>false</BOOL>
            </VAR>
            <VAR name = "UrbanTerresPropLossModel">
                <SCOPE Class = "LinkEmbedControl">
                    <VAR name = "ReferenceType">
                        <STRING>&quot;Unlinked&quot;</STRING>
                    </VAR>
                    <VAR name = "Component">
                        <VAR name = "Two_Ray">
                            <SCOPE Class = "UrbanTerrestrialPropagationLossModel">
                                <VAR name = "Version">
                                    <STRING>&quot;1.0.0 a&quot;</STRING>
                                </VAR>
                                <VAR name = "IdentifierInformation">
                                    <SCOPE>
                                        <VAR name = "Identifier">
                                            <STRING>&quot;{3B8E3250-7248-4701-8308-115FE1F71F11}&quot;</STRING>
                                        </VAR>
                                        <VAR name = "Version">
                                            <STRING>&quot;1&quot;</STRING>
                                        </VAR>
                                        <VAR name = "SourceIdentifierInformation">
                                            <SCOPE>
                                                <VAR name = "Identifier">
                                                    <STRING>&quot;{60FA4C9B-5D74-4743-A449-66CEB6DFC97B}&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Version">
                                                    <STRING>&quot;1&quot;</STRING>
                                                </VAR>
                                                <VAR name = "SdfInformation">
                                                    <SCOPE Class = "SCOPE">
                                                        <VAR name = "Version">
                                                            <STRING>&quot;0.0&quot;</STRING>
                                                        </VAR>
                                                        <VAR name = "Url">
                                                            <STRING>&quot;&quot;</STRING>
                                                        </VAR>
                                                    </SCOPE>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                        <VAR name = "SdfInformation">
                                            <SCOPE Class = "SCOPE">
                                                <VAR name = "Version">
                                                    <STRING>&quot;0.0&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Url">
                                                    <STRING>&quot;&quot;</STRING>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                    </SCOPE>
                                </VAR>
                                <VAR name = "ComponentName">
                                    <STRING>&quot;Two_Ray&quot;</STRING>
                                </VAR>
                                <VAR name = "Description">
                                    <STRING>&quot;Two Ray (Fourth Power Law) atmospheric absorption model&quot;</STRING>
                                </VAR>
                                <VAR name = "Type">
                                    <STRING>&quot;Two Ray&quot;</STRING>
                                </VAR>
                                <VAR name = "UserComment">
                                    <STRING>&quot;Two Ray (Fourth Power Law) atmospheric absorption model&quot;</STRING>
                                </VAR>
                                <VAR name = "ReadOnly">
                                    <BOOL>false</BOOL>
                                </VAR>
                                <VAR name = "Clonable">
                                    <BOOL>true</BOOL>
                                </VAR>
                                <VAR name = "Category">
                                    <STRING>&quot;@Top&quot;</STRING>
                                </VAR>
                                <VAR name = "SurfaceTemperature">
                                    <QUANTITY Dimension = "Temperature" Unit = "K">
                                        <REAL>273.15</REAL>
                                    </QUANTITY>
                                </VAR>
                                <VAR name = "LossFactor">
                                    <REAL>1</REAL>
                                </VAR>
                            </SCOPE>
                        </VAR>
                    </VAR>
                </SCOPE>
            </VAR>
            <VAR name = "UseCustomA">
                <BOOL>false</BOOL>
            </VAR>
            <VAR name = "UseCustomB">
                <BOOL>false</BOOL>
            </VAR>
            <VAR name = "UseCustomC">
                <BOOL>false</BOOL>
            </VAR>
        </SCOPE>
    </VAR>
    <VAR name = "EarthTemperature">
        <QUANTITY Dimension = "Temperature" Unit = "K">
            <REAL>290</REAL>
        </QUANTITY>
    </VAR>
    <VAR name = "RainOutagePercent">
        <REAL>0.1</REAL>
    </VAR>
    <VAR name = "ActiveCommSystem">
        <LINKTOOBJ>
            <STRING>&quot;None&quot;</STRING>
        </LINKTOOBJ>
    </VAR>
    <VAR name = "MagneticNorthPoleLatitude">
        <QUANTITY Dimension = "AngleUnit" Unit = "rad">
            <REAL>1.387536755335492</REAL>
        </QUANTITY>
    </VAR>
    <VAR name = "MagneticNorthPoleLongitude">
        <QUANTITY Dimension = "AngleUnit" Unit = "rad">
            <REAL>-1.204277183876087</REAL>
        </QUANTITY>
    </VAR>
</SCOPE>        END RfEnv

        BEGIN LaserEnv
<?xml version = "1.0" standalone = "yes"?>
<SCOPE>
    <VAR name = "PropagationChannel">
        <SCOPE>
            <VAR name = "EnableAtmosphericLossModel">
                <BOOL>false</BOOL>
            </VAR>
            <VAR name = "AtmosphericLossModel">
                <SCOPE Class = "LinkEmbedControl">
                    <VAR name = "ReferenceType">
                        <STRING>&quot;Unlinked&quot;</STRING>
                    </VAR>
                    <VAR name = "Component">
                        <VAR name = "Beer-Bouguer-Lambert_Law">
                            <SCOPE Class = "LaserAtmosphericAbsorptionLossModel">
                                <VAR name = "Version">
                                    <STRING>&quot;1.0.0 a&quot;</STRING>
                                </VAR>
                                <VAR name = "IdentifierInformation">
                                    <SCOPE>
                                        <VAR name = "Identifier">
                                            <STRING>&quot;{D638C40E-52EE-4AE9-901A-29F117D3B64D}&quot;</STRING>
                                        </VAR>
                                        <VAR name = "Version">
                                            <STRING>&quot;1&quot;</STRING>
                                        </VAR>
                                        <VAR name = "SourceIdentifierInformation">
                                            <SCOPE>
                                                <VAR name = "Identifier">
                                                    <STRING>&quot;{6896684B-630D-472D-8027-385684842E74}&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Version">
                                                    <STRING>&quot;1&quot;</STRING>
                                                </VAR>
                                                <VAR name = "SdfInformation">
                                                    <SCOPE Class = "SCOPE">
                                                        <VAR name = "Version">
                                                            <STRING>&quot;0.0&quot;</STRING>
                                                        </VAR>
                                                        <VAR name = "Url">
                                                            <STRING>&quot;&quot;</STRING>
                                                        </VAR>
                                                    </SCOPE>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                        <VAR name = "SdfInformation">
                                            <SCOPE Class = "SCOPE">
                                                <VAR name = "Version">
                                                    <STRING>&quot;0.0&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Url">
                                                    <STRING>&quot;&quot;</STRING>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                    </SCOPE>
                                </VAR>
                                <VAR name = "ComponentName">
                                    <STRING>&quot;Beer-Bouguer-Lambert_Law&quot;</STRING>
                                </VAR>
                                <VAR name = "Description">
                                    <STRING>&quot;Model atmospheric loss for laser receivers using the Beer-Bouguer-Lambert Law&quot;</STRING>
                                </VAR>
                                <VAR name = "Type">
                                    <STRING>&quot;Beer-Bouguer-Lambert Law&quot;</STRING>
                                </VAR>
                                <VAR name = "UserComment">
                                    <STRING>&quot;Model atmospheric loss for laser receivers using the Beer-Bouguer-Lambert Law&quot;</STRING>
                                </VAR>
                                <VAR name = "ReadOnly">
                                    <BOOL>false</BOOL>
                                </VAR>
                                <VAR name = "Clonable">
                                    <BOOL>true</BOOL>
                                </VAR>
                                <VAR name = "Category">
                                    <STRING>&quot;@Top&quot;</STRING>
                                </VAR>
                                <VAR name = "LayerList">
                                    <LIST>
                                        <SCOPE>
                                            <VAR name = "LayerNum">
                                                <INT>1</INT>
                                            </VAR>
                                            <VAR name = "LayerTop">
                                                <QUANTITY Dimension = "DistanceUnit" Unit = "m">
                                                    <REAL>100000</REAL>
                                                </QUANTITY>
                                            </VAR>
                                            <VAR name = "ExtinctionCoefficient">
                                                <QUANTITY Dimension = "UnitlessPerSmallDistance" Unit = "m^-1">
                                                    <REAL>0</REAL>
                                                </QUANTITY>
                                            </VAR>
                                        </SCOPE>
                                    </LIST>
                                </VAR>
                                <VAR name = "EnableEvenlySpacedHeights">
                                    <BOOL>true</BOOL>
                                </VAR>
                                <VAR name = "MaxLayerHeight">
                                    <QUANTITY Dimension = "DistanceUnit" Unit = "m">
                                        <REAL>100000</REAL>
                                    </QUANTITY>
                                </VAR>
                            </SCOPE>
                        </VAR>
                    </VAR>
                </SCOPE>
            </VAR>
            <VAR name = "EnableTropoScintLossModel">
                <BOOL>false</BOOL>
            </VAR>
            <VAR name = "TropoScintLossModel">
                <SCOPE Class = "LinkEmbedControl">
                    <VAR name = "ReferenceType">
                        <STRING>&quot;Unlinked&quot;</STRING>
                    </VAR>
                    <VAR name = "Component">
                        <VAR name = "ITU-R_P1814">
                            <SCOPE Class = "LaserTropoScintLossModel">
                                <VAR name = "Version">
                                    <STRING>&quot;1.0.0 a&quot;</STRING>
                                </VAR>
                                <VAR name = "IdentifierInformation">
                                    <SCOPE>
                                        <VAR name = "Identifier">
                                            <STRING>&quot;{583C0B7D-6D99-4801-B112-178473D516A0}&quot;</STRING>
                                        </VAR>
                                        <VAR name = "Version">
                                            <STRING>&quot;1&quot;</STRING>
                                        </VAR>
                                        <VAR name = "SourceIdentifierInformation">
                                            <SCOPE>
                                                <VAR name = "Identifier">
                                                    <STRING>&quot;{651AF2C8-7D6D-457E-8F99-1FB796A460BF}&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Version">
                                                    <STRING>&quot;1&quot;</STRING>
                                                </VAR>
                                                <VAR name = "SdfInformation">
                                                    <SCOPE Class = "SCOPE">
                                                        <VAR name = "Version">
                                                            <STRING>&quot;0.0&quot;</STRING>
                                                        </VAR>
                                                        <VAR name = "Url">
                                                            <STRING>&quot;&quot;</STRING>
                                                        </VAR>
                                                    </SCOPE>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                        <VAR name = "SdfInformation">
                                            <SCOPE Class = "SCOPE">
                                                <VAR name = "Version">
                                                    <STRING>&quot;0.0&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Url">
                                                    <STRING>&quot;&quot;</STRING>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                    </SCOPE>
                                </VAR>
                                <VAR name = "ComponentName">
                                    <STRING>&quot;ITU-R_P1814&quot;</STRING>
                                </VAR>
                                <VAR name = "Description">
                                    <STRING>&quot;ITU-R P1814&quot;</STRING>
                                </VAR>
                                <VAR name = "Type">
                                    <STRING>&quot;ITU-R P1814&quot;</STRING>
                                </VAR>
                                <VAR name = "UserComment">
                                    <STRING>&quot;ITU-R P1814&quot;</STRING>
                                </VAR>
                                <VAR name = "ReadOnly">
                                    <BOOL>false</BOOL>
                                </VAR>
                                <VAR name = "Clonable">
                                    <BOOL>true</BOOL>
                                </VAR>
                                <VAR name = "Category">
                                    <STRING>&quot;@Top&quot;</STRING>
                                </VAR>
                                <VAR name = "AtmosphericTurbulenceModel">
                                    <VAR name = "Constant">
                                        <SCOPE Class = "AtmosphericTurbulenceModel">
                                            <VAR name = "ConstantRefractiveIndexStructureParameter">
                                                <REAL>1.7e-14</REAL>
                                            </VAR>
                                            <VAR name = "Type">
                                                <STRING>&quot;Constant&quot;</STRING>
                                            </VAR>
                                        </SCOPE>
                                    </VAR>
                                </VAR>
                            </SCOPE>
                        </VAR>
                    </VAR>
                </SCOPE>
            </VAR>
        </SCOPE>
    </VAR>
</SCOPE>        END LaserEnv

        BEGIN CommRad
        END CommRad

        BEGIN RadarCrossSection
<?xml version = "1.0" standalone = "yes"?>
<SCOPE>
    <VAR name = "Model">
        <SCOPE Class = "LinkEmbedControl">
            <VAR name = "ReferenceType">
                <STRING>&quot;Unlinked&quot;</STRING>
            </VAR>
            <VAR name = "Component">
                <VAR name = "Radar_Cross_Section">
                    <SCOPE Class = "RCS">
                        <VAR name = "Version">
                            <STRING>&quot;1.0.0 a&quot;</STRING>
                        </VAR>
                        <VAR name = "IdentifierInformation">
                            <SCOPE>
                                <VAR name = "Identifier">
                                    <STRING>&quot;{536EEE2E-7502-441E-832F-6948A75ACCDB}&quot;</STRING>
                                </VAR>
                                <VAR name = "Version">
                                    <STRING>&quot;1&quot;</STRING>
                                </VAR>
                                <VAR name = "SourceIdentifierInformation">
                                    <SCOPE>
                                        <VAR name = "Identifier">
                                            <STRING>&quot;{EF03E656-5AB7-4F70-A363-4753683F2BD4}&quot;</STRING>
                                        </VAR>
                                        <VAR name = "Version">
                                            <STRING>&quot;1&quot;</STRING>
                                        </VAR>
                                        <VAR name = "SdfInformation">
                                            <SCOPE Class = "SCOPE">
                                                <VAR name = "Version">
                                                    <STRING>&quot;0.0&quot;</STRING>
                                                </VAR>
                                                <VAR name = "Url">
                                                    <STRING>&quot;&quot;</STRING>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                    </SCOPE>
                                </VAR>
                                <VAR name = "SdfInformation">
                                    <SCOPE Class = "SCOPE">
                                        <VAR name = "Version">
                                            <STRING>&quot;0.0&quot;</STRING>
                                        </VAR>
                                        <VAR name = "Url">
                                            <STRING>&quot;&quot;</STRING>
                                        </VAR>
                                    </SCOPE>
                                </VAR>
                            </SCOPE>
                        </VAR>
                        <VAR name = "ComponentName">
                            <STRING>&quot;Radar_Cross_Section&quot;</STRING>
                        </VAR>
                        <VAR name = "Description">
                            <STRING>&quot;Radar Cross Section&quot;</STRING>
                        </VAR>
                        <VAR name = "Type">
                            <STRING>&quot;Radar Cross Section&quot;</STRING>
                        </VAR>
                        <VAR name = "UserComment">
                            <STRING>&quot;Radar Cross Section&quot;</STRING>
                        </VAR>
                        <VAR name = "ReadOnly">
                            <BOOL>false</BOOL>
                        </VAR>
                        <VAR name = "Clonable">
                            <BOOL>true</BOOL>
                        </VAR>
                        <VAR name = "Category">
                            <STRING>&quot;@Top&quot;</STRING>
                        </VAR>
                        <VAR name = "FrequencyBandList">
                            <LIST>
                                <SCOPE>
                                    <VAR name = "MinFrequency">
                                        <QUANTITY Dimension = "BandwidthUnit" Unit = "Hz">
                                            <REAL>2997920</REAL>
                                        </QUANTITY>
                                    </VAR>
                                    <VAR name = "ComputeTypeStrategy">
                                        <VAR name = "Constant Value">
                                            <SCOPE Class = "RCS Compute Strategy">
                                                <VAR name = "ConstantValue">
                                                    <QUANTITY Dimension = "RcsUnit" Unit = "sqm">
                                                        <REAL>1</REAL>
                                                    </QUANTITY>
                                                </VAR>
                                                <VAR name = "Type">
                                                    <STRING>&quot;Constant Value&quot;</STRING>
                                                </VAR>
                                                <VAR name = "ComponentName">
                                                    <STRING>&quot;Constant Value&quot;</STRING>
                                                </VAR>
                                            </SCOPE>
                                        </VAR>
                                    </VAR>
                                    <VAR name = "SwerlingCase">
                                        <STRING>&quot;0&quot;</STRING>
                                    </VAR>
                                </SCOPE>
                            </LIST>
                        </VAR>
                    </SCOPE>
                </VAR>
            </VAR>
        </SCOPE>
    </VAR>
</SCOPE>        END RadarCrossSection

        BEGIN RadarClutter
<?xml version = "1.0" standalone = "yes"?>
<SCOPE>
    <VAR name = "ClutterMap">
        <VAR name = "Constant Coefficient">
            <SCOPE Class = "Clutter Map">
                <VAR name = "ClutterCoefficient">
                    <QUANTITY Dimension = "RatioUnit" Unit = "units">
                        <REAL>1</REAL>
                    </QUANTITY>
                </VAR>
                <VAR name = "Type">
                    <STRING>&quot;Constant Coefficient&quot;</STRING>
                </VAR>
                <VAR name = "ComponentName">
                    <STRING>&quot;Constant Coefficient&quot;</STRING>
                </VAR>
            </SCOPE>
        </VAR>
    </VAR>
</SCOPE>        END RadarClutter

        BEGIN Gator
            RPOComponentsLoaded		 False
        END Gator

        BEGIN Crdn
            BEGIN AXES
                Type		 AXES_GENALIGNED
                Name		 EMR
                Description		 <Enter description (up to 300 chars)>
                AbsolutePath		 CentralBody/Earth
                Alignment		
                 1.0000000000000002e+00
                 0.0000000000000000e+00
                 0.0000000000000000e+00
                AlignmentUiSequence		 123
                AlignmentUiCoordType		 4
                AlignmentReference		
                BEGIN VECTOR
                    Type		 VECTOR_LINKTO
                    Name		 EMR.X
                    AbsolutePath		 CentralBody/Moon
                END VECTOR
                AlignmentLimit		  0.0000000000000000e+00
                Constraint		
                 0.0000000000000000e+00
                 0.0000000000000000e+00
                 1.0000000000000000e+00
                ConstraintUiSequence		 123
                ConstraintUiCoordType		 4
                ConstraintReference		
                BEGIN VECTOR
                    Type		 VECTOR_LINKTO
                    Name		 EMR.Z
                    AbsolutePath		 CentralBody/Moon
                END VECTOR
                ConstraintLimit		  0.0000000000000000e+00
                BodySpin		 Yes
                UniDirConstraint		 No
                LabelX		 X
                LabelY		 Y
                LabelZ		 Z
            END AXES
            BEGIN AXES
                Type		 AXES_GENALIGNED
                Name		 SER
                Description		 <Enter description (up to 300 chars)>
                AbsolutePath		 CentralBody/Earth
                Alignment		
                -1.0000000000000000e+00
                 0.0000000000000000e+00
                 0.0000000000000000e+00
                AlignmentUiSequence		 123
                AlignmentUiCoordType		 4
                AlignmentReference		
                BEGIN VECTOR
                    Type		 VECTOR_LINKTO
                    Name		 Sun
                    AbsolutePath		 CentralBody/Earth
                END VECTOR
                AlignmentLimit		  0.0000000000000000e+00
                Constraint		
                 0.0000000000000000e+00
                 0.0000000000000000e+00
                 1.0000000000000000e+00
                ConstraintUiSequence		 123
                ConstraintUiCoordType		 4
                ConstraintReference		
                BEGIN VECTOR
                    Type		 VECTOR_LINKTO
                    Name		 EclipticNormal
                    AbsolutePath		 CentralBody/Earth
                END VECTOR
                ConstraintLimit		  0.0000000000000000e+00
                BodySpin		 Yes
                UniDirConstraint		 No
                LabelX		 X
                LabelY		 Y
                LabelZ		 Z
            END AXES
            BEGIN POINT
                Type		 POINT_LIBRATION
                Name		 EML3
                Description		 <Enter description (up to 300 chars)>
                AbsolutePath		 CentralBody/Earth
                Primary		 CentralBody/Earth
                Secondary		 CentralBody/Charon
                Secondary		 CentralBody/Moon
                PtType		 2
            END POINT
            BEGIN SYSTEM
                Type		 SYSTEM_ASSEMBLED
                Name		 ECSER
                Description		 <Enter description (up to 300 chars)>
                AbsolutePath		 CentralBody/Earth
                Origin		
                BEGIN POINT
                    Type		 POINT_LINKTO
                    Name		 Center
                    AbsolutePath		 CentralBody/Earth
                END POINT
                Axes		
                BEGIN AXES
                    Type		 AXES_LINKTO
                    Name		 SER
                    AbsolutePath		 CentralBody/Earth
                END AXES
            END SYSTEM
            BEGIN AXES
                Type		 AXES_GENALIGNED
                Name		 EMR
                Description		 <Enter description (up to 300 chars)>
                AbsolutePath		 CentralBody/Moon
                Alignment		
                -1.0000000000000000e+00
                 0.0000000000000000e+00
                 0.0000000000000000e+00
                AlignmentUiSequence		 123
                AlignmentUiCoordType		 4
                AlignmentReference		
                BEGIN VECTOR
                    Type		 VECTOR_LINKTO
                    Name		 Earth
                    AbsolutePath		 CentralBody/Moon
                END VECTOR
                AlignmentLimit		  0.0000000000000000e+00
                Constraint		
                 0.0000000000000000e+00
                 0.0000000000000000e+00
                 1.0000000000000000e+00
                ConstraintUiSequence		 123
                ConstraintUiCoordType		 4
                ConstraintReference		
                BEGIN VECTOR
                    Type		 VECTOR_LINKTO
                    Name		 EclipticNormal
                    AbsolutePath		 CentralBody/Moon
                END VECTOR
                ConstraintLimit		  0.0000000000000000e+00
                BodySpin		 Yes
                UniDirConstraint		 No
                LabelX		 X
                LabelY		 Y
                LabelZ		 Z
            END AXES
            BEGIN POINT
                Type		 POINT_LIBRATION
                Name		 L3
                Description		 <Enter description (up to 300 chars)>
                AbsolutePath		 CentralBody/Moon
                Primary		 CentralBody/Earth
                Secondary		 CentralBody/Moon
                PtType		 2
            END POINT
            BEGIN POINT
                Type		 POINT_LIBRATION
                Name		 L4
                Description		 <Enter description (up to 300 chars)>
                AbsolutePath		 CentralBody/Moon
                Primary		 CentralBody/Earth
                Secondary		 CentralBody/Moon
                PtType		 3
            END POINT
            BEGIN POINT
                Type		 POINT_LIBRATION
                Name		 L5
                Description		 <Enter description (up to 300 chars)>
                AbsolutePath		 CentralBody/Moon
                Primary		 CentralBody/Earth
                Secondary		 CentralBody/Moon
                PtType		 4
            END POINT
            BEGIN SYSTEM
                Type		 SYSTEM_ASSEMBLED
                Name		 MCEMR
                Description		 <Enter description (up to 300 chars)>
                AbsolutePath		 CentralBody/Moon
                Origin		
                BEGIN POINT
                    Type		 POINT_LINKTO
                    Name		 Center
                    AbsolutePath		 CentralBody/Moon
                END POINT
                Axes		
                BEGIN AXES
                    Type		 AXES_LINKTO
                    Name		 EMR
                    AbsolutePath		 CentralBody/Moon
                END AXES
            END SYSTEM
        END Crdn

        BEGIN SpiceExt
        END SpiceExt

        BEGIN FlightScenExt
        END FlightScenExt

        BEGIN Graphics

            BEGIN Animation

                StartTime		 28 Aug 2024 04:01:00.000000000
                EndTime		 28 Apr 2027 04:01:00.000000000
                CurrentTime		 7 Nov 2026 00:11:06.541999996
                Direction		 Forward
                UpdateDelta		 600
                RefreshDelta		 0.010000
                XRealTimeMult		 1
                RealTimeOffset		 0
                XRtStartFromPause		                Yes		
                TimeArrayIncrement		 1

            END Animation


            BEGIN DisplayFlags
                ShowLabels		 On
                ShowPassLabel		 Off
                ShowElsetNum		 Off
                ShowGndTracks		 On
                ShowGndMarkers		 On
                ShowOrbitMarkers		 On
                ShowPlanetOrbits		 Off
                ShowPlanetCBIPos		 On
                ShowPlanetCBILabel		 On
                ShowPlanetGndPos		 On
                ShowPlanetGndLabel		 On
                ShowSensors		 On
                ShowWayptMarkers		 Off
                ShowWayptTurnMarkers		 Off
                ShowOrbits		 On
                ShowDtedRegions		 Off
                ShowAreaTgtCentroids		 On
                ShowToolBar		 On
                ShowStatusBar		 On
                ShowScrollBars		 On
                AllowAnimUpdate		 On
                AccShowLine		 On
                AccAnimHigh		 On
                AccStatHigh		 On
                AccAnimLineLineWidth		  1.0000000000000000e+00
                ShowPrintButton		 On
                ShowAnimButtons		 On
                ShowAnimModeButtons		 On
                ShowZoomMsrButtons		 On
                ShowMapCbButton		 Off
            END DisplayFlags

            BEGIN WinFonts

                Consolas,12,700,0
                Consolas,14,700,0
                Consolas,20,700,0

            END WinFonts

            BEGIN MapData

                BEGIN TerrainConverterData
                    NorthLat		  0.0000000000000000e+00
                    EastLon		  0.0000000000000000e+00
                    SouthLat		  0.0000000000000000e+00
                    WestLon		  0.0000000000000000e+00
                    ColorByRGB		 No
                    AltsFromMSL		 No
                    UseColorRamp		 Yes
                    UseRegionMinMax		 Yes
                    SizeSameAsSrc		 Yes
                    MinAltHSV		  0.0000000000000000e+00  6.9999999999999996e-01  8.0000000000000004e-01  4.0000000000000002e-01
                    MaxAltHSV		  1.0000000000000000e+06  0.0000000000000000e+00  2.0000000000000001e-01  1.0000000000000000e+00
                    SmoothColors		 Yes
                    CreateChunkTrn		 No
                    OutputFormat		 PDTTX
                END TerrainConverterData

                DisableDefKbdActions		 Off
                TextShadowStyle		 Dark
                TextShadowColor		 #000000
                BingLevelOfDetailScale		 2
                BEGIN Map
                    MapNum		 1
                    TrackingMode		 LatLon
                    PickEnabled		 On
                    PanEnabled		 On

                    BEGIN MapAttributes
                        PrimaryBody		 Earth
                        SecondaryBody		 Sun
                        CenterLatitude		 0
                        CenterLongitude		 155.0569654530082
                        ProjectionAltitude		 63621860
                        FieldOfView		 35
                        OrthoDisplayDistance		 20000000
                        TransformTrajectory		 On
                        EquatorialRadius		 6378137
                        BackgroundColor		 #000000
                        LatLonLines		 On
                        LatSpacing		 30
                        LonSpacing		 30
                        LatLonLineColor		 #999999
                        LatLonLineStyle		 2
                        ShowOrthoDistGrid		 Off
                        OrthoGridXSpacing		 5
                        OrthoGridYSpacing		 5
                        OrthoGridColor		 #ffffff
                        ShowImageExtents		 Off
                        ImageExtentLineColor		 #ffffff
                        ImageExtentLineStyle		 0
                        ImageExtentLineWidth		 1
                        ShowImageNames		 Off
                        ImageNameFont		 0
                        Projection		 EquidistantCylindrical
                        Resolution		 VeryLow
                        CoordinateSys		 ECF
                        UseBackgroundImage		 On
                        UseBingForBackground		 Off
                        BingType		 Aerial
                        BingLogoHorizAlign		 Right
                        BingLogoVertAlign		 Bottom
                        BackgroundImageFile		 Basic.bmp
                        UseNightLights		 Off
                        NightLightsFactor		 3.5
                        UseCloudsFile		 Off
                        BEGIN ZoomLocations
                            BEGIN ZoomLocation
                                CenterLat		 0
                                CenterLon		 155.0569654530082
                                ZoomWidth		 251.112676056338
                                ZoomHeight		 180
                            END ZoomLocation
                        END ZoomLocations
                        UseVarAspectRatio		 No
                        SwapMapResolution		 Yes
                        NoneToVLowSwapDist		 2000000
                        VLowToLowSwapDist		 20000
                        LowToMediumSwapDist		 10000
                        MediumToHighSwapDist		 5000
                        HighToVHighSwapDist		 1000
                        VHighToSHighSwapDist		 100
                        BEGIN Axes
                            DisplayAxes		 no
                            CoordSys		 CBI
                            2aryCB		 Sun
                            Display+x		 yes
                            Label+x		 yes
                            Color+x		 #ffffff
                            Scale+x		 3
                            Display-x		 yes
                            Label-x		 yes
                            Color-x		 #ffffff
                            Scale-x		 3
                            Display+y		 yes
                            Label+y		 yes
                            Color+y		 #ffffff
                            Scale+y		 3
                            Display-y		 yes
                            Label-y		 yes
                            Color-y		 #ffffff
                            Scale-y		 3
                            Display+z		 yes
                            Label+z		 yes
                            Color+z		 #ffffff
                            Scale+z		 3
                            Display-z		 yes
                            Label-z		 yes
                            Color-z		 #ffffff
                            Scale-z		 3
                        END Axes

                    END MapAttributes

                    BEGIN MapList
                        BEGIN Detail
                            Alias		 RWDB2_Coastlines
                            Show		 Yes
                            Color		 #8fbc8f
                        END Detail
                        BEGIN Detail
                            Alias		 RWDB2_International_Borders
                            Show		 No
                            Color		 #8fbc8f
                        END Detail
                        BEGIN Detail
                            Alias		 RWDB2_Islands
                            Show		 No
                            Color		 #8fbc8f
                        END Detail
                        BEGIN Detail
                            Alias		 RWDB2_Lakes
                            Show		 No
                            Color		 #87cefa
                        END Detail
                        BEGIN Detail
                            Alias		 RWDB2_Provincial_Borders
                            Show		 No
                            Color		 #8fbc8f
                        END Detail
                        BEGIN Detail
                            Alias		 RWDB2_Rivers
                            Show		 No
                            Color		 #87cefa
                        END Detail
                    END MapList


                    BEGIN MapAnnotations
                    END MapAnnotations

                    BEGIN DisplayFlags
                        ShowLabels		 On
                        ShowPassLabel		 Off
                        ShowElsetNum		 Off
                        ShowGndTracks		 On
                        ShowGndMarkers		 On
                        ShowOrbitMarkers		 On
                        ShowPlanetOrbits		 Off
                        ShowPlanetCBIPos		 On
                        ShowPlanetCBILabel		 On
                        ShowPlanetGndPos		 On
                        ShowPlanetGndLabel		 On
                        ShowSensors		 On
                        ShowWayptMarkers		 Off
                        ShowWayptTurnMarkers		 Off
                        ShowOrbits		 On
                        ShowDtedRegions		 Off
                        ShowAreaTgtCentroids		 On
                        ShowToolBar		 On
                        ShowStatusBar		 On
                        ShowScrollBars		 On
                        AllowAnimUpdate		 Off
                        AccShowLine		 On
                        AccAnimHigh		 On
                        AccStatHigh		 On
                        AccAnimLineLineWidth		  1.0000000000000000e+00
                        ShowPrintButton		 On
                        ShowAnimButtons		 On
                        ShowAnimModeButtons		 On
                        ShowZoomMsrButtons		 On
                        ShowMapCbButton		 Off
                    END DisplayFlags

                    BEGIN RecordMovie
                        OutputFormat		 VIDEO
                        SdfSelected		 No
                        Directory		 C:\Users\haozh\Documents\STK 12
                        BaseName		 Frame
                        Digits		 4
                        Frame		 0
                        LastAnimTime		 0
                        OutputMode		 Normal
                        HiResAssembly		 Assemble
                        HRWidth		 6000
                        HRHeight		 4500
                        HRDPI		 600
                        UseSnapInterval		 No
                        SnapInterval		 0
                        VideoCodec		 "H264"
                        Framerate		 30
                        Bitrate		 10000000
                    END RecordMovie


                    BEGIN TimeDisplay
                        Show		 0
                        TextColor		 #ffffff
                        TextTranslucency		 0
                        ShowBackground		 0
                        BackColor		 #4d4d4d
                        BackTranslucency		 0.4
                        XPosition		 20
                        YPosition		 -20
                    END TimeDisplay

                    BEGIN LightingData
                        DisplayAltitude		 0
                        SubsolarPoint		 Off
                        SubsolarPointColor		 #ffff00
                        SubsolarPointMarkerStyle		 2

                        ShowUmbraLine		 Off
                        UmbraLineColor		 #000000
                        UmbraLineStyle		 0
                        UmbraLineWidth		 2
                        FillUmbra		 On
                        UmbraFillColor		 #000000
                        ShowSunlightLine		 Off
                        SunlightLineColor		 #ffff00
                        SunlightLineStyle		 0
                        SunlightLineWidth		 2
                        FillSunlight		 On
                        SunlightFillColor		 #ffffff
                        SunlightMinOpacity		 0
                        SunlightMaxOpacity		 0.2
                        UmbraMaxOpacity		 0.7
                        UmbraMinOpacity		 0.4
                    END LightingData
                END Map

                BEGIN MapStyles

                    UseStyleTime		 No

                    BEGIN Style
                        Name		 DefaultWithBing
                        Time		 604740
                        UpdateDelta		 10

                        BEGIN MapAttributes
                            PrimaryBody		 Earth
                            SecondaryBody		 Sun
                            CenterLatitude		 0
                            CenterLongitude		 0
                            ProjectionAltitude		 63621860
                            FieldOfView		 35
                            OrthoDisplayDistance		 20000000
                            TransformTrajectory		 On
                            EquatorialRadius		 6378137
                            BackgroundColor		 #000000
                            LatLonLines		 On
                            LatSpacing		 30
                            LonSpacing		 30
                            LatLonLineColor		 #999999
                            LatLonLineStyle		 2
                            ShowOrthoDistGrid		 Off
                            OrthoGridXSpacing		 5
                            OrthoGridYSpacing		 5
                            OrthoGridColor		 #ffffff
                            ShowImageExtents		 Off
                            ImageExtentLineColor		 #ffffff
                            ImageExtentLineStyle		 0
                            ImageExtentLineWidth		 1
                            ShowImageNames		 Off
                            ImageNameFont		 0
                            Projection		 EquidistantCylindrical
                            Resolution		 VeryLow
                            CoordinateSys		 ECF
                            UseBackgroundImage		 On
                            UseBingForBackground		 Off
                            BingType		 Aerial
                            BingLogoHorizAlign		 Right
                            BingLogoVertAlign		 Bottom
                            BackgroundImageFile		 Basic.bmp
                            UseNightLights		 Off
                            NightLightsFactor		 3.5
                            UseCloudsFile		 Off
                            BEGIN ZoomLocations
                                BEGIN ZoomLocation
                                    CenterLat		 0
                                    CenterLon		 0
                                    ZoomWidth		 359.999998
                                    ZoomHeight		 180
                                END ZoomLocation
                            END ZoomLocations
                            UseVarAspectRatio		 No
                            SwapMapResolution		 Yes
                            NoneToVLowSwapDist		 2000000
                            VLowToLowSwapDist		 20000
                            LowToMediumSwapDist		 10000
                            MediumToHighSwapDist		 5000
                            HighToVHighSwapDist		 1000
                            VHighToSHighSwapDist		 100
                            BEGIN Axes
                                DisplayAxes		 no
                                CoordSys		 CBI
                                2aryCB		 Sun
                                Display+x		 yes
                                Label+x		 yes
                                Color+x		 #ffffff
                                Scale+x		 3
                                Display-x		 yes
                                Label-x		 yes
                                Color-x		 #ffffff
                                Scale-x		 3
                                Display+y		 yes
                                Label+y		 yes
                                Color+y		 #ffffff
                                Scale+y		 3
                                Display-y		 yes
                                Label-y		 yes
                                Color-y		 #ffffff
                                Scale-y		 3
                                Display+z		 yes
                                Label+z		 yes
                                Color+z		 #ffffff
                                Scale+z		 3
                                Display-z		 yes
                                Label-z		 yes
                                Color-z		 #ffffff
                                Scale-z		 3
                            END Axes

                        END MapAttributes

                        BEGIN MapList
                            BEGIN Detail
                                Alias		 RWDB2_Coastlines
                                Show		 Yes
                                Color		 #8fbc8f
                            END Detail
                            BEGIN Detail
                                Alias		 RWDB2_International_Borders
                                Show		 No
                                Color		 #8fbc8f
                            END Detail
                            BEGIN Detail
                                Alias		 RWDB2_Islands
                                Show		 No
                                Color		 #8fbc8f
                            END Detail
                            BEGIN Detail
                                Alias		 RWDB2_Lakes
                                Show		 No
                                Color		 #87cefa
                            END Detail
                            BEGIN Detail
                                Alias		 RWDB2_Provincial_Borders
                                Show		 No
                                Color		 #8fbc8f
                            END Detail
                            BEGIN Detail
                                Alias		 RWDB2_Rivers
                                Show		 No
                                Color		 #87cefa
                            END Detail
                        END MapList


                        BEGIN MapAnnotations
                        END MapAnnotations

                        BEGIN RecordMovie
                            OutputFormat		 VIDEO
                            SdfSelected		 No
                            Directory		 C:\Users\haozh\Documents\STK 12
                            BaseName		 Frame
                            Digits		 4
                            Frame		 0
                            LastAnimTime		 0
                            OutputMode		 Normal
                            HiResAssembly		 Assemble
                            HRWidth		 6000
                            HRHeight		 4500
                            HRDPI		 600
                            UseSnapInterval		 No
                            SnapInterval		 0
                            VideoCodec		 "H264"
                            Framerate		 30
                            Bitrate		 10000000
                        END RecordMovie


                        BEGIN TimeDisplay
                            Show		 0
                            TextColor		 #ffffff
                            TextTranslucency		 0
                            ShowBackground		 0
                            BackColor		 #4d4d4d
                            BackTranslucency		 0.4
                            XPosition		 20
                            YPosition		 -20
                        END TimeDisplay

                        BEGIN LightingData
                            DisplayAltitude		 0
                            SubsolarPoint		 Off
                            SubsolarPointColor		 #ffff00
                            SubsolarPointMarkerStyle		 2

                            ShowUmbraLine		 Off
                            UmbraLineColor		 #000000
                            UmbraLineStyle		 0
                            UmbraLineWidth		 2
                            FillUmbra		 On
                            UmbraFillColor		 #000000
                            ShowSunlightLine		 Off
                            SunlightLineColor		 #ffff00
                            SunlightLineStyle		 0
                            SunlightLineWidth		 2
                            FillSunlight		 On
                            SunlightFillColor		 #ffffff
                            SunlightMinOpacity		 0
                            SunlightMaxOpacity		 0.2
                            UmbraMaxOpacity		 0.7
                            UmbraMinOpacity		 0.4
                        END LightingData

                        ShowDtedRegions		 Off

                    END Style

                    BEGIN Style
                        Name		 DefaultWithoutBing
                        Time		 604740
                        UpdateDelta		 10

                        BEGIN MapAttributes
                            PrimaryBody		 Earth
                            SecondaryBody		 Sun
                            CenterLatitude		 0
                            CenterLongitude		 0
                            ProjectionAltitude		 63621860
                            FieldOfView		 35
                            OrthoDisplayDistance		 20000000
                            TransformTrajectory		 On
                            EquatorialRadius		 6378137
                            BackgroundColor		 #000000
                            LatLonLines		 On
                            LatSpacing		 30
                            LonSpacing		 30
                            LatLonLineColor		 #999999
                            LatLonLineStyle		 2
                            ShowOrthoDistGrid		 Off
                            OrthoGridXSpacing		 5
                            OrthoGridYSpacing		 5
                            OrthoGridColor		 #ffffff
                            ShowImageExtents		 Off
                            ImageExtentLineColor		 #ffffff
                            ImageExtentLineStyle		 0
                            ImageExtentLineWidth		 1
                            ShowImageNames		 Off
                            ImageNameFont		 0
                            Projection		 EquidistantCylindrical
                            Resolution		 VeryLow
                            CoordinateSys		 ECF
                            UseBackgroundImage		 On
                            UseBingForBackground		 Off
                            BingType		 Aerial
                            BingLogoHorizAlign		 Right
                            BingLogoVertAlign		 Bottom
                            BackgroundImageFile		 Basic.bmp
                            UseNightLights		 Off
                            NightLightsFactor		 3.5
                            UseCloudsFile		 Off
                            BEGIN ZoomLocations
                                BEGIN ZoomLocation
                                    CenterLat		 0
                                    CenterLon		 0
                                    ZoomWidth		 359.999998
                                    ZoomHeight		 180
                                END ZoomLocation
                            END ZoomLocations
                            UseVarAspectRatio		 No
                            SwapMapResolution		 Yes
                            NoneToVLowSwapDist		 2000000
                            VLowToLowSwapDist		 20000
                            LowToMediumSwapDist		 10000
                            MediumToHighSwapDist		 5000
                            HighToVHighSwapDist		 1000
                            VHighToSHighSwapDist		 100
                            BEGIN Axes
                                DisplayAxes		 no
                                CoordSys		 CBI
                                2aryCB		 Sun
                                Display+x		 yes
                                Label+x		 yes
                                Color+x		 #ffffff
                                Scale+x		 3
                                Display-x		 yes
                                Label-x		 yes
                                Color-x		 #ffffff
                                Scale-x		 3
                                Display+y		 yes
                                Label+y		 yes
                                Color+y		 #ffffff
                                Scale+y		 3
                                Display-y		 yes
                                Label-y		 yes
                                Color-y		 #ffffff
                                Scale-y		 3
                                Display+z		 yes
                                Label+z		 yes
                                Color+z		 #ffffff
                                Scale+z		 3
                                Display-z		 yes
                                Label-z		 yes
                                Color-z		 #ffffff
                                Scale-z		 3
                            END Axes

                        END MapAttributes

                        BEGIN MapList
                            BEGIN Detail
                                Alias		 RWDB2_Coastlines
                                Show		 Yes
                                Color		 #8fbc8f
                            END Detail
                            BEGIN Detail
                                Alias		 RWDB2_International_Borders
                                Show		 No
                                Color		 #8fbc8f
                            END Detail
                            BEGIN Detail
                                Alias		 RWDB2_Islands
                                Show		 No
                                Color		 #8fbc8f
                            END Detail
                            BEGIN Detail
                                Alias		 RWDB2_Lakes
                                Show		 No
                                Color		 #87cefa
                            END Detail
                            BEGIN Detail
                                Alias		 RWDB2_Provincial_Borders
                                Show		 No
                                Color		 #8fbc8f
                            END Detail
                            BEGIN Detail
                                Alias		 RWDB2_Rivers
                                Show		 No
                                Color		 #87cefa
                            END Detail
                        END MapList


                        BEGIN MapAnnotations
                        END MapAnnotations

                        BEGIN RecordMovie
                            OutputFormat		 VIDEO
                            SdfSelected		 No
                            Directory		 C:\Users\haozh\Documents\STK 12
                            BaseName		 Frame
                            Digits		 4
                            Frame		 0
                            LastAnimTime		 0
                            OutputMode		 Normal
                            HiResAssembly		 Assemble
                            HRWidth		 6000
                            HRHeight		 4500
                            HRDPI		 600
                            UseSnapInterval		 No
                            SnapInterval		 0
                            VideoCodec		 "H264"
                            Framerate		 30
                            Bitrate		 3000000
                        END RecordMovie


                        BEGIN TimeDisplay
                            Show		 0
                            TextColor		 #ffffff
                            TextTranslucency		 0
                            ShowBackground		 0
                            BackColor		 #4d4d4d
                            BackTranslucency		 0.4
                            XPosition		 20
                            YPosition		 -20
                        END TimeDisplay

                        BEGIN LightingData
                            DisplayAltitude		 0
                            SubsolarPoint		 Off
                            SubsolarPointColor		 #ffff00
                            SubsolarPointMarkerStyle		 2

                            ShowUmbraLine		 Off
                            UmbraLineColor		 #000000
                            UmbraLineStyle		 0
                            UmbraLineWidth		 2
                            FillUmbra		 On
                            UmbraFillColor		 #000000
                            ShowSunlightLine		 Off
                            SunlightLineColor		 #ffff00
                            SunlightLineStyle		 0
                            SunlightLineWidth		 2
                            FillSunlight		 On
                            SunlightFillColor		 #ffffff
                            SunlightMinOpacity		 0
                            SunlightMaxOpacity		 0.2
                            UmbraMaxOpacity		 0.7
                            UmbraMinOpacity		 0.4
                        END LightingData

                        ShowDtedRegions		 Off

                    END Style

                END MapStyles

            END MapData

            BEGIN GfxClassPref

            END GfxClassPref


            BEGIN ConnectGraphicsOptions

                AsyncPickReturnUnique		 OFF

            END ConnectGraphicsOptions

        END Graphics

        BEGIN Overlays
        END Overlays

        BEGIN VO
        END VO

        BEGIN ScenSpaceEnvironmentGfx

            BEGIN Gfx

                BEGIN MagFieldGfx
                    Show		 No
                    ColorBy		 Magnitude
                    ColorScale		 Log
                    ColorRampStart		 #0000ff
                    ColorRampStart		 #0000ff
                    ColorRampStop		 #ff0000
                    MaxTranslucency		 0.7
                    LineStyle		 0
                    LineWidth		 2
                    FieldLineRefresh		 300
                    NumLats		 8
                    NumLongs		 6
                    StartLat		 15
                    StopLat		 85
                    RefLongitude		 3.141592653589793
                    MainField		 IGRF
                    ExternalField		 None
                    IGRF_UpdateRate		 86400
                END MagFieldGfx

            END Gfx

        END ScenSpaceEnvironmentGfx

        BEGIN DIS

            BEGIN General

                Verbose		 Off
                Processing		 Off
                Statistics		 Off
                ExerciseID		 -1
                ForceID		 -1

            END General


            BEGIN Output

                Version		 5
                ExerciseID		 1
                forceID		 1
                HeartbeatTimer		 5
                DistanceThresh		 1
                OrientThresh		 3

            END Output


            BEGIN Time

                Mode		 rtPDUTimestamp

            END Time


            BEGIN PDUInfo


            END PDUInfo


            BEGIN Parameters

                ParmData		 COLORFRIENDLY blue
                ParmData		 COLORNEUTRAL white
                ParmData		 COLOROPFORCE red
                ParmData		 MAXDRELSETS 1000

            END Parameters


            BEGIN Network

                NetIF		 Default
                Mode		 Broadcast
                McastIP		 224.0.0.1
                Port		 3000
                rChannelBufferSize		 65000
                ReadBufferSize		 1500
                QueuePollPeriod		 20
                MaxRcvQueueEntries		 1000
                MaxRcvIOThreads		 4
                sChannelBufferSize		 65000

            END Network


            BEGIN EntityTypeDef


# order: kind:domain:country:catagory:subCatagory:specific:xtra ( -1 = * )


            END EntityTypeDef


            BEGIN EntityFilter
                Include		 *:*:*
            END EntityFilter

        END DIS

    END Extensions

    BEGIN SubObjects

        Class Place

            703		
            D29		
            G96		
            Haleakala		
            I52		
            K19		
            Kunming		
            Miyun		
            Montreal		
            N56		
            O17		
            O46		
            O49111		
            P13		
            PlaceOnMoon		
            SouthPole		
            U62		
            U74		
            WHO		

        END Class

        Class Planet

            Moon		
            Vesta		

        END Class

        Class Satellite

            CE6		
            CE6_Bill		
            CE6_Obs		
            CE6_Obs_251130		
            CE6_Obs_HelioJ2K		
            DRO		
            DRO_Optical		
            DRO_Test		
            DROA_0828		
            DROA_0829		
            DROA_0923		
            DROA_1027		
            DROA_BillG		
            DROA_Obs		
            DROA_OEM		
            DROB_0828		
            DROB_0923		
            DROB_BillG		
            DROB_BillG_PostDRD		
            DROB_OEM		
            GEO		
            Hakuto_BillG		
            IBEX_BillG		
            SatPlace		
            TD1		
            TD1_optRecon		

        END Class

    END SubObjects

    BEGIN References
        Instance *
            *		
        END Instance
        Instance Place/703
            Place/703		
        END Instance
        Instance Place/D29
            Place/D29		
        END Instance
        Instance Place/G96
            Place/G96		
        END Instance
        Instance Place/Haleakala
            Place/Haleakala		
        END Instance
        Instance Place/I52
            Place/I52		
        END Instance
        Instance Place/K19
            Place/K19		
        END Instance
        Instance Place/Kunming
            Place/Kunming		
        END Instance
        Instance Place/Miyun
            *		
            Place/Miyun		
        END Instance
        Instance Place/Montreal
            Place/Montreal		
        END Instance
        Instance Place/N56
            Place/N56		
        END Instance
        Instance Place/O17
            Place/O17		
        END Instance
        Instance Place/O46
            Place/O46		
        END Instance
        Instance Place/O49111
            Place/O49111		
        END Instance
        Instance Place/P13
            Place/P13		
        END Instance
        Instance Place/PlaceOnMoon
            Place/PlaceOnMoon		
        END Instance
        Instance Place/SouthPole
            Place/SouthPole		
        END Instance
        Instance Place/U62
            Place/U62		
        END Instance
        Instance Place/U74
            Place/U74		
        END Instance
        Instance Place/WHO
            Place/WHO		
        END Instance
        Instance Planet/Moon
            *		
            Planet/Moon		
        END Instance
        Instance Planet/Vesta
            Planet/Vesta		
        END Instance
        Instance Satellite/CE6
            Satellite/CE6		
        END Instance
        Instance Satellite/CE6_Bill
            Satellite/CE6_Bill		
        END Instance
        Instance Satellite/CE6_Obs
            Satellite/CE6_Obs		
        END Instance
        Instance Satellite/CE6_Obs_251130
            Satellite/CE6_Obs_251130		
        END Instance
        Instance Satellite/CE6_Obs_HelioJ2K
            Satellite/CE6_Obs_HelioJ2K		
        END Instance
        Instance Satellite/DRO
            Satellite/DRO		
            Satellite/DRO/Sensor/ACam4		
        END Instance
        Instance Satellite/DRO/Sensor/ACam4
            Satellite/DRO/Sensor/ACam4		
        END Instance
        Instance Satellite/DROA_0828
            Satellite/DROA_0828		
        END Instance
        Instance Satellite/DROA_0829
            Satellite/DROA_0829		
        END Instance
        Instance Satellite/DROA_0923
            Satellite/DROA_0923		
        END Instance
        Instance Satellite/DROA_1027
            Satellite/DROA_1027		
        END Instance
        Instance Satellite/DROA_BillG
            Satellite/DROA_BillG		
        END Instance
        Instance Satellite/DROA_OEM
            Satellite/DROA_OEM		
            Satellite/DROA_OEM/Sensor/ACam		
        END Instance
        Instance Satellite/DROA_OEM/Sensor/ACam
            Satellite/DROA_OEM/Sensor/ACam		
        END Instance
        Instance Satellite/DROA_Obs
            Satellite/DROA_Obs		
        END Instance
        Instance Satellite/DROB_0828
            Satellite/DROB_0828		
        END Instance
        Instance Satellite/DROB_0923
            Satellite/DROB_0923		
        END Instance
        Instance Satellite/DROB_BillG
            Satellite/DROB_BillG		
        END Instance
        Instance Satellite/DROB_BillG_PostDRD
            Satellite/DROB_BillG_PostDRD		
        END Instance
        Instance Satellite/DROB_OEM
            Satellite/DROB_OEM		
            Satellite/DROB_OEM/Sensor/BN		
            Satellite/DROB_OEM/Sensor/BW		
            Satellite/DROB_OEM/Sensor/RotAtna		
        END Instance
        Instance Satellite/DROB_OEM/Sensor/BN
            Satellite/DROB_OEM/Sensor/BN		
        END Instance
        Instance Satellite/DROB_OEM/Sensor/BW
            Satellite/DROB_OEM/Sensor/BW		
        END Instance
        Instance Satellite/DROB_OEM/Sensor/RotAtna
            Satellite/DROB_OEM/Sensor/RotAtna		
        END Instance
        Instance Satellite/DRO_Optical
            Satellite/DRO_Optical		
        END Instance
        Instance Satellite/DRO_Test
            Satellite/DRO_Test		
            Satellite/DRO_Test/Sensor/ACam		
        END Instance
        Instance Satellite/DRO_Test/Sensor/ACam
            Satellite/DRO_Test/Sensor/ACam		
        END Instance
        Instance Satellite/GEO
            Satellite/GEO		
        END Instance
        Instance Satellite/Hakuto_BillG
            Satellite/Hakuto_BillG		
        END Instance
        Instance Satellite/IBEX_BillG
            Satellite/IBEX_BillG		
        END Instance
        Instance Satellite/SatPlace
            Satellite/SatPlace		
        END Instance
        Instance Satellite/TD1
            Satellite/TD1		
        END Instance
        Instance Satellite/TD1_optRecon
            Satellite/TD1_optRecon		
        END Instance
    END References

END Scenario
