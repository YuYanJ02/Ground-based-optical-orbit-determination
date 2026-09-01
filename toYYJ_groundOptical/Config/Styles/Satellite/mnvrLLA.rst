stk.v.12.0
WrittenBy    STK_v12.4.0

BEGIN ReportStyle

    BEGIN ClassId
        Class		 Satellite
    END ClassId

    BEGIN Header
        StyleType		 0
        Date		 Yes
        Name		 Yes
        IsHidden		 No
        DescShort		 No
        DescLong		 No
        YLog10		 No
        Y2Log10		 No
        YUseWholeNumbers		 No
        Y2UseWholeNumbers		 No
        InvertAxes		 No
        VerticalGridLines		 No
        HorizontalGridLines		 No
        HorizontalGridBands		 Yes
        AnnotationType		 Spaced
        NumAnnotations		 3
        NumAngularAnnotations		 5
        ShowYAnnotations		 Yes
        AnnotationRotation		 1
        BackgroundColor		 #ffffff
        ForegroundColor		 #000000
        ViewableDuration		 3600
        RealTimeMode		 No
        DayLinesStatus		 1
        LegendStatus		 1
        LegendLocation		 1

        BEGIN PostProcessor
            Destination		 0
            Destination		 1
            Destination		 2
            Destination		 3
        END PostProcessor
        NumSections		 1
    END Header

    BEGIN Section
        Name		 Section 1
        ClassName		 Satellite
        NameInTitle		 No
        ExpandMethod		 0
        PropMask		 34560
        ShowIntervals		 No
        NumIntervals		 0
        NumLines		 1

        BEGIN Line
            Name		 Line 1
            NumElements		 5

            BEGIN Element
                Name		 Astrogator Maneuver Ephemeris Block Final-Maneuver-Time
                IsIndepVar		 No
                Title		 Time
                NameInTitle		 Yes
                Service		 AstrogatorSegmentFinal
                Type		 Maneuver
                Element		 Time
                SumAllowedMask		 1559
                SummaryOnly		 No
                DataType		 0
                UnitType		 2
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                UseScenUnits		 No
                BEGIN Units
                    DateFormat		 GregorianLCL
                END Units
            END Element

            BEGIN Element
                Name		 Astrogator Maneuver Ephemeris Block Final-Maneuver-DeltaV
                IsIndepVar		 No
                Title		 DeltaV
                NameInTitle		 Yes
                Service		 AstrogatorSegmentFinal
                Type		 Maneuver
                Element		 DeltaV
                SumAllowedMask		 1559
                SummaryOnly		 No
                DataType		 0
                UnitType		 4
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                UseScenUnits		 No
                BEGIN Units
                    DistanceUnit		 Meters
                    TimeUnit		 Seconds
                END Units
            END Element

            BEGIN Element
                Name		 Astrogator Maneuver Ephemeris Block Final-Geodetic-Longitude
                IsIndepVar		 No
                Title		 Longitude
                NameInTitle		 Yes
                Service		 AstrogatorSegmentFinal
                Type		 Geodetic
                Element		 Longitude
                SumAllowedMask		 1559
                SummaryOnly		 No
                DataType		 0
                UnitType		 3
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                UseScenUnits		 Yes
            END Element

            BEGIN Element
                Name		 Astrogator Maneuver Ephemeris Block Final-Geodetic-Latitude
                IsIndepVar		 No
                Title		 Latitude
                NameInTitle		 Yes
                Service		 AstrogatorSegmentFinal
                Type		 Geodetic
                Element		 Latitude
                SumAllowedMask		 1559
                SummaryOnly		 No
                DataType		 0
                UnitType		 3
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                UseScenUnits		 Yes
            END Element

            BEGIN Element
                Name		 Astrogator Maneuver Ephemeris Block Final-Geodetic-Altitude
                IsIndepVar		 No
                Title		 Altitude
                NameInTitle		 Yes
                Service		 AstrogatorSegmentFinal
                Type		 Geodetic
                Element		 Altitude
                SumAllowedMask		 1559
                SummaryOnly		 No
                DataType		 0
                UnitType		 0
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                UseScenUnits		 Yes
            END Element
        END Line
    END Section

    BEGIN LineAnnotations
    END LineAnnotations
END ReportStyle

