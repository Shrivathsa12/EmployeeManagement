sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"department/test/integration/pages/DepartmentsList",
	"department/test/integration/pages/DepartmentsObjectPage",
	"department/test/integration/pages/EmployeesObjectPage"
], function (JourneyRunner, DepartmentsList, DepartmentsObjectPage, EmployeesObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('department') + '/test/flp.html#app-preview',
        pages: {
			onTheDepartmentsList: DepartmentsList,
			onTheDepartmentsObjectPage: DepartmentsObjectPage,
			onTheEmployeesObjectPage: EmployeesObjectPage
        },
        async: true
    });

    return runner;
});

