import {csrfToken} from "../utils/csrf";

export const fetchUserBills = async () => {
    const response = await fetch("/api/v1/user_bills")
    return await response.json()
}

export const userSaveBill = async (bill) => {

    console.log(bill);
    try {
        const response = await fetch("/api/v1/bills", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": csrfToken
            },
            body: JSON.stringify({
                bill: {
                    bill_id: bill.number,
                    title: bill.title,
                    introduced_date: bill.introducedDate,
                    update_date: bill.updateDate,
                    congress: bill.congress,
                    bill_type: bill.type,
                    bill_url: bill.url,
                    latest_action: bill.latestAction,
                    sponsor_first_name: bill.sponsorFirstName,
                    sponsor_last_name: bill.sponsorLastName,
                    sponsor_party: bill.sponsorParty,
                    sponsor_state: bill.sponsorState,
                    sponsor_url: bill.sponsorUrl
                }
            })
        })


        if (!response.ok) {
            throw new Error(`HTTP error saving bill: ${response.status}`)
        }
        const result = await response.json();
    } catch (e) {
        console.error("Error saving bill: ", e)
    }
}