sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"managerkpi/test/integration/pages/LeaveAnalyticsList",
	"managerkpi/test/integration/pages/LeaveAnalyticsObjectPage"
], function (JourneyRunner, LeaveAnalyticsList, LeaveAnalyticsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('managerkpi') + '/test/flp.html#app-preview',
        pages: {
			onTheLeaveAnalyticsList: LeaveAnalyticsList,
			onTheLeaveAnalyticsObjectPage: LeaveAnalyticsObjectPage
        },
        async: true
    });

    return runner;
});

