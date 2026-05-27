sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"leaverequest/test/integration/pages/LeaveRequestsList",
	"leaverequest/test/integration/pages/LeaveRequestsObjectPage"
], function (JourneyRunner, LeaveRequestsList, LeaveRequestsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('leaverequest') + '/test/flp.html#app-preview',
        pages: {
			onTheLeaveRequestsList: LeaveRequestsList,
			onTheLeaveRequestsObjectPage: LeaveRequestsObjectPage
        },
        async: true
    });

    return runner;
});

