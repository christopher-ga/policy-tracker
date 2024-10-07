import {csrfToken} from "../utils/csrf";

export const fetchBillsData = async () => {
    try {

        const response = await fetch("/api/v1/bills/congress_bills");

        if (!response.ok) {
            throw new Error(`HTTP error fetching congress bill data: ${response.status}`)
        }

        const billsData = await response.json();
        return billsData.bills

    } catch (e) {
        console.error("Error fetching congress_bill: ", e);
    }
}

export const fetchBillData = async (url) => {

    const response = await fetch("/api/v1/bills/congress_bills", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "X-CSRF-TOKEN": csrfToken
        },
        body: JSON.stringify({url}),
    });

    if (!response.ok) {
        throw new Error(`HTTP error fetching congress bill data for bill ${bill}: ${response.status}`)
    }


    return await response.json()
}

export const batchFetchBillData = async (bills) => {
    await Promise.all(bills.map(async (bill) => {
        try {
            const secondaryBillData = await fetchBillData(bill.url)

            bill.introducedDate = secondaryBillData.bill?.introducedDate;
            bill.latestAction = secondaryBillData.bill?.latestAction?.text;
            bill.sponsorFirstName = secondaryBillData.bill?.sponsors[0]?.firstName;
            bill.sponsorLastName = secondaryBillData.bill?.sponsors[0]?.lastName;
            bill.sponsorParty = secondaryBillData.bill?.sponsors[0]?.party;
            bill.sponsorState = secondaryBillData.bill?.sponsors[0]?.state;
            bill.sponsorUrl = secondaryBillData.bill?.sponsors[0]?.url;

        } catch (e) {
            console.error("Error fetching bill data: ", e)
        }
    }));
}

export const batchFetchSponsorImage = async (bills) => {
    await Promise.all(bills.map(async (bill) => {
        try {
            const sponsorData = await fetchBillData(bill.sponsorUrl)

            bill.sponsorImage = sponsorData.member.depiction.imageUrl

        } catch (e) {
            console.error("Error fetching bill sponsor image: ", e)
        }
    }));
}

export const searchForBills = async (searchTerms) => {

    try {

        const response = await fetch("/api/v1/bills/congress_bills_search", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": csrfToken
            },
            body: JSON.stringify({searchTerms})
        })

        if (!response.ok) {
            throw new Error(`HTTP error searching for bills: ${response.status}`)
        }


        return await response.json()
    } catch (e) {
        console.error("Error searching for bills: ", e)
    }

}



