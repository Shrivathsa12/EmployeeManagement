sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"managerdashboard/test/integration/pages/Manager_LeaveRequestsList",
	"managerdashboard/test/integration/pages/Manager_LeaveRequestsObjectPage"
], function (JourneyRunner, Manager_LeaveRequestsList, Manager_LeaveRequestsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('managerdashboard') + '/test/flp.html#app-preview',
        pages: {
			onTheManager_LeaveRequestsList: Manager_LeaveRequestsList,
			onTheManager_LeaveRequestsObjectPage: Manager_LeaveRequestsObjectPage
        },
        async: true
    });

    return runner;
});

