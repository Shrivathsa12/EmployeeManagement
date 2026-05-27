sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'managerdashboard',
            componentId: 'Manager_LeaveRequestsList',
            contextPath: '/Manager_LeaveRequests'
        },
        CustomPageDefinitions
    );
});