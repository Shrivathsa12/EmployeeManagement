const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {


    const { Employees, LeaveRequests } = this.entities('LeaveManagementService');
    //console.log(LeaveRequests);

    this.before('READ', LeaveRequests, (req) => {
        if (req.user.is('Employee') && !req.user.is('Administrator')) {
            req.query.where({ createdBy: req.user.id });
            console.log("Leave read access for employee:", req.user.id)
        }
    });
    this.before('READ', Employees, (req) => {
        if (req.user.is('Employee') && !req.user.is('Administrator')) {
            req.query.where({ ID: req.user.id });
            console.log("Employee read access for employee:", req.user.id);
        }
    });

    this.before('CREATE', LeaveRequests, async (req) => {
        console.log('before CREATE triggered');

        const { StartDate, EndDate } = req.data;

        const start = new Date(StartDate);
        const end = new Date(EndDate);

        if (end < start) {
            return req.error(400, 'EndDate cannot be before StartDate');
        }

        const numberOfDays =
            Math.floor((end - start) / (1000 * 60 * 60 * 24)) + 1;

        req.data.NumberOfDays = numberOfDays;

        const userEmail = req.user.id;

        console.log("Determined user email:", userEmail);

        const employee = await SELECT.one
            .from(Employees)
            .where({ Email: userEmail });

        if (!employee) return req.error(404, 'Employee not found');

        req.data.Employee_ID = employee.ID;

        console.log("emp details:", employee.ID);

        if (numberOfDays > employee.LeaveBalance) {
            return req.error(
                403,
                `Insufficient leave balance. Available: ${employee.LeaveBalance}`
            );
        }

        const overlap = await SELECT.one
            .from(LeaveRequests)
            .where({
                Employee_ID: employee.ID,
                Status: { '!=': 'Rejected' },
                StartDate: { '<=': EndDate },
                EndDate: { '>=': StartDate }
            });

        if (overlap) {
            console.log('Overlap Found:', overlap);
            return req.error(400, 'Leave request overlaps with existing leave request');
        }

        console.log('No Overlap Found');
    });



    // AFTER LEAVE REQ UPDATE - UPDATING LEAVE BALANCE 
    this.after("UPDATE", LeaveRequests, async (data, req) => {

        const leaveRequest = await SELECT.one.from(LeaveRequests).where({ ID: data.ID });
        console.log(leaveRequest);

        if (!leaveRequest) return req.error(404, 'Leave request not found');

        const employee = await SELECT.one.from(Employees).where({ ID: leaveRequest.Employee_ID });
        console.log(employee);

        if (!employee) return req.error(404, 'Employee not found');

        // APPROVED
        if (data.Status === 'Approved') {
            const newBalance = employee.LeaveBalance - leaveRequest.NumberOfDays;
            await UPDATE(Employees).set({ LeaveBalance: newBalance }).where({ ID: leaveRequest.Employee_ID });
            console.log('Leave balance deducted');
        }

        // REJECTED
        else if (data.Status === 'Rejected') {
            const newBalance = employee.LeaveBalance + leaveRequest.NumberOfDays;
            await UPDATE(Employees).set({ LeaveBalance: newBalance }).where({ ID: leaveRequest.Employee_ID });
            console.log('Leave balance restored');
        }

    });


    const Departments = cds.entities('FinalTask').Departments;
    const { TravelRequests } = this.entities('TravelManagementService');

    this.before('READ', TravelRequests, (req) => {
        if (req.user.is('Employee') && !req.user.is('Administrator')) {
            req.query.where({ createdBy: req.user.id });
            console.log("Travel Request read access for employee:", req.user.id);
        }
    });

    // CHECKING TRAVEL BUDGET LIMIT THAT IS WITHIN LIMIT
    this.before("CREATE", TravelRequests, async (req) => {

        const userEmail = req.user.id;

        console.log("Logged in user:", userEmail);

        const employee = await SELECT.one
            .from(Employees)
            .where({ Email: userEmail });

        if (!employee) {
            return req.error(400, "Employee not found");
        }

        req.data.Employee_ID = employee.ID;

        const department = await SELECT.one
            .from(Departments)
            .where({ ID: employee.Department_ID });

        if (!department) {
            return req.error(400, "Department not found");
        }

        if (req.data.EstimatedBudget > department.BudgetLimit) {
            return req.error(
                400,
                `Budget exceeds department limit of ${department.BudgetLimit}`
            );
        }

        console.log("Budget validated successfully");
    });


    //ACTION FOR SUBMIT LEAVE REQ
    this.on("submitLeaveRequest", async (req) => {

        const ID = req.params[0]?.ID || req.params[0];

        console.log("Submit triggered for:", ID);

        const leave = await SELECT.one.from(LeaveRequests).where({ ID });

        if (!leave) return req.error(404, "Leave request not found");

        await UPDATE(LeaveRequests).set({ Status: "Pending" }).where({ ID });

        req.info("Leave request submitted successfully");

        return {
            message: "Leave request submitted successfully",
            ID,
            Status: "Pending"
        };
    });



    // ACTION FOR APPROVE LEAVE REQ
    this.on("approveLeave", async (req) => {
        const ID = req.params[0]?.ID

        const leaveRequest = await SELECT.one.from(LeaveRequests).where({ ID })
        console.log(leaveRequest);

        if (!leaveRequest) return req.error("Leave request not found")
        if (leaveRequest.Status === 'Approved') {
            req.error("Leave request already approved")
            return;
        }

        const employee = await SELECT.one.from(Employees).where({ ID: leaveRequest.Employee_ID });
        if (!employee) return req.error("Employee not found");
        if (!employee.Manager_ID) {
            return req.error(400, "Employee has no manager assigned");
        }

        const requestedDays = Number(leaveRequest.NumberOfDays);
        const availableBalance = Number(employee.LeaveBalance);

        if (requestedDays > availableBalance) {
            return req.error(
                400,
                `Insufficient Leave Balance \n Available Leave Balance is ${availableBalance}`
            );
        }

        const updateLeaveRequest = await UPDATE(LeaveRequests).set({
            Status: 'Approved',
            ApprovalDate: new Date(),
            ApprovedBy_ID: employee.Manager_ID
        })
            .where({ ID });

           // const leaveRequestupdate = await SELECT.one.from(LeaveRequests).where({ ID })

        const newBalance = availableBalance - requestedDays;

        console.log(newBalance);

        const updateEmployee = await UPDATE(Employees).set({ LeaveBalance: newBalance }).where({ ID: leaveRequest.Employee_ID })
        //console.log(updateEmployee);
        console.log("Leave Approved Successfullu")

        const audit = cds.log('audit');

        audit.info('APPROVE_LEAVE', {
            action: "APPROVE_LEAVE",
            leaveRequest: ID,
            approvedBy: employee.Manager_ID,
            employee: leaveRequest.Employee_ID,
            deductedDays: leaveRequest.NumberOfDays,
            remainingBalance: newBalance,
            timestamp: new Date()
        });


        req.info("Leave approved successfully");
        return {
            message: "Leave approved successfully",
            remainingBalance: newBalance
        };
    })

    // ACTION FOR REJECT LEAVE REQ
    this.on("rejectLeave", async (req) => {

        const ID = req.params[0]?.ID;
        const { Reason } = req.data;

        console.log("Reject triggered for:", ID);

        const leaveRequest = await SELECT.one.from(LeaveRequests).where({ ID });

        if (!leaveRequest) return req.error(404, "Leave request not found");

        if (leaveRequest.Status === "Rejected") return req.error(400, "Leave request already rejected");

        const employee = await SELECT.one.from(Employees).where({ ID: leaveRequest.Employee_ID });

        if (!employee) return req.error(404, "Employee not found");

        if (!employee.Manager_ID) return req.error(400, "Employee has no manager assigned");


        if (leaveRequest.Status === "Approved") {

            const restoredBalance =
                Number(employee.LeaveBalance) +
                Number(leaveRequest.NumberOfDays);

            await UPDATE(Employees).set({ LeaveBalance: restoredBalance }).where({ ID: leaveRequest.Employee_ID });

            console.log("Leave balance restored:", restoredBalance);
        }

        // Update leave request
        await UPDATE(LeaveRequests).set({
            Status: "Rejected",
            ApprovedBy_ID: employee.Manager_ID,
            Reason: Reason
        }).where({ ID });

        const updatedLeaveRequest = await SELECT.one.from(LeaveRequests).where({ ID });
        const audit = cds.log("audit");

        audit.info("REJECT_LEAVE", {
            action: "REJECT_LEAVE",
            leaveRequest: ID,
            rejectedBy: employee.Manager_ID,
            employee: leaveRequest.Employee_ID,
            reason: Reason,
            timestamp: new Date()
        });

        console.log("Leave rejected successfully");
        req.warn("Leave rejected successfully");
        return {
            message: "Leave rejected successfully",
            ID,
            Status: updatedLeaveRequest.Status
        };
    });

    //FUNCTION FOR GETTING LEAVE BALANCE OF EMPLOYEE
this.on("getLeaveBalance", async (req) => {
    const ID = req.params[0]?.ID;

    const leaveRequest = await SELECT.one.from(LeaveRequests).columns('Employee_ID').where({ ID });

    console.log("Leave Request:", leaveRequest);
    if (!leaveRequest) return req.error(404, "Leave request not found");

    const employee = await SELECT.one.from(Employees).columns('LeaveBalance', 'Name').where({ ID: leaveRequest.Employee_ID });

    if (!employee) return req.error(404, "Employee not found");

    const balance = employee.LeaveBalance;

    req.info(`Leave balance for ${employee.Name}: ${balance}`);
    console.log("Leave Balance:", balance);
});


    // ACTION FOR CANCELL LEAVE REQ
    this.on('cancelLeave', async (req) => {
        const { ID } = req.params[0];
        const leave = await SELECT.one.from(LeaveRequests).where({ ID });
        if (!leave) {
            return req.error(404, 'Leave request not found');
        }
        if (
            leave.Status !== 'Pending'
        ) {
            return req.error(400, 'Only Pending requests can be cancelled');
        }
        await UPDATE(LeaveRequests).set({ Status: 'Cancelled' }).where({ ID });
        req.info("Leave canclled succussfully")
        return true;
    });



    //ACTION FOR APPROVE TRAVEL REQ
    this.on("approveTravel", async (req) => {

        const ID = req.params[0]?.ID;

        console.log("Approve triggered for:", ID);

        const travelRequest = await SELECT.one
            .from(TravelRequests)
            .where({ ID });

        if (!travelRequest)
            return req.error(404, "Travel request not found");

        if (travelRequest.Status === "Approved")
            return req.error(400, "Travel request already approved");

        const employee = await SELECT.one
            .from(Employees)
            .where({ ID: travelRequest.Employee_ID });

        if (!employee)
            return req.error(404, "Employee not found");

        if (!employee.Manager_ID)
            return req.error(400, "Employee has no manager assigned");

        await UPDATE(TravelRequests)
            .set({
                Status: "Approved",
                ApprovalDate: new Date(),
                Approver_ID: employee.Manager_ID
            })
            .where({ ID });

        const updatedTravel = await SELECT.one
            .from(TravelRequests)
            .where({ ID });

        const audit = cds.log("audit");

        audit.info("APPROVE_TRAVEL", {
            action: "APPROVE_TRAVEL",
            travelRequest: ID,
            approvedBy: employee.Manager_ID,
            employee: travelRequest.Employee_ID,
            destination: travelRequest.Destination,
            estimatedBudget: travelRequest.EstimatedBudget,
            timestamp: new Date()
        });

        req.info("Travel approved successfully");

        return {
            message: "Travel approved successfully",
            ID,
            Status: updatedTravel.Status
        };
    });

    this.on("completeTravel", async (req) => {

        const ID = req.params[0]?.ID;

        console.log("Complete triggered for:", ID);

        const travelRequest = await SELECT.one
            .from(TravelRequests)
            .where({ ID });

        if (!travelRequest)
            return req.error(404, "Travel request not found");

        if (travelRequest.Status !== "Approved")
            return req.error(400, "Travel request must be approved before it can be completed");

        if (travelRequest.Status === "Completed")
            return req.error(400, "Travel request is already completed");

        const employee = await SELECT.one
            .from(Employees)
            .where({ ID: travelRequest.Employee_ID });

        if (!employee)
            return req.error(404, "Employee not found");

        await UPDATE(TravelRequests)
            .set({ Status: "Completed" })
            .where({ ID });

        const updatedTravel = await SELECT.one
            .from(TravelRequests)
            .where({ ID });

        const audit = cds.log("audit");

        audit.info("COMPLETE_TRAVEL", {
            action: "COMPLETE_TRAVEL",
            travelRequest: ID,
            completedBy: travelRequest.Approver_ID,
            employee: employee.Name,
            destination: travelRequest.Destination,
            estimatedBudget: travelRequest.EstimatedBudget,
            timestamp: new Date()
        });

        req.info("Travel completed successfully");

        return {
            message: "Travel completed successfully",
            ID,
            Status: updatedTravel.Status
        };
    });

    // ACTION FOR REJECT TRAVEL REQ
    this.on("rejectTravel", async (req) => {

        const ID = req.params[0]?.ID;
        const { Reason } = req.data;

        console.log("Reject triggered for:", ID);

        const travelRequest = await SELECT.one
            .from(TravelRequests)
            .where({ ID });

        if (!travelRequest)
            return req.error(404, "Travel request not found");

        if (travelRequest.Status === "Rejected")
            return req.error(400, "Travel request already rejected");

        const employee = await SELECT.one
            .from(Employees)
            .where({ ID: travelRequest.Employee_ID });

        if (!employee)
            return req.error(404, "Employee not found");

        if (!employee.Manager_ID)
            return req.error(400, "Employee has no manager assigned");

        await UPDATE(TravelRequests)
            .set({
                Status: "Rejected",
                Approver_ID: employee.Manager_ID,
                Reason
            })
            .where({ ID });

        const updatedTravel = await SELECT.one
            .from(TravelRequests)
            .where({ ID });

        const audit = cds.log("audit");

        audit.info("REJECT_TRAVEL", {
            action: "REJECT_TRAVEL",
            travelRequest: ID,
            rejectedBy: employee.Manager_ID,
            employee: travelRequest.Employee_ID,
            reason: Reason,
            timestamp: new Date()
        });

        req.warn("Travel rejected successfully");

        return {
            message: "Travel rejected successfully",
            ID,
            Status: updatedTravel.Status
        };
    });

    // KPI TILES FOR LEAVE USING ANALYTICAL REQQ
    this.on("READ", "LeaveRequestKPI", async (req) => {

        const total = await SELECT.one.from(LeaveRequests).columns`count(ID) as count`;

        const pending = await SELECT.one.from(LeaveRequests).where({ Status: 'Pending' }).columns`count(ID) as count`;

        const approved = await SELECT.one.from(LeaveRequests).where({ Status: 'Approved' }).columns`count(ID) as count`;

        const rejected = await SELECT.one.from(LeaveRequests).where({ Status: 'Rejected' }).columns`count(ID) as count`;

        return [{
            KPI_ID: cds.utils.uuid(),

            TotalRequests: total.count || 0,

            PendingRequests: pending.count || 0,

            ApprovedRequests: approved.count || 0,

            RejectedRequests: rejected.count || 0
        }];
    });




    this.on('updateActualBudget', TravelRequests, async (req) => {
        const ID = req.params[0]?.ID
        const { ActualBudget } = req.data;

        if (!ActualBudget && ActualBudget !== 0)
            return req.error(400, 'Actual Budget is required');

        const travel = await SELECT.one.from(TravelRequests).where({ ID });
        if (!travel) return req.error(404, 'Travel request not found');

        if (travel.Status !== 'Completed')
            return req.error(400, 'Actual budget can only be updated for Completed requests');

        if (ActualBudget > travel.EstimatedBudget) {

            req.info(`Warning: Actual budget ₹${ActualBudget} exceeds estimated ₹${travel.EstimatedBudget}`);
        }

        await UPDATE(TravelRequests).set({ ActualBudget }).where({ ID });

        const difference = ActualBudget - travel.EstimatedBudget;

        if (difference > 0) req.info(`Actual budget exceeded estimated budget by ₹${difference}`);
        else if (difference < 0) {
            req.info(`Budget saved: ₹${Math.abs(difference)}`);

        } else req.info("Actual budget matches estimated budget");

        return `Actual Budget updated successfully`;
    });

})
