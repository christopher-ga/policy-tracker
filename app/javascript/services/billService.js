import {csrfToken} from "../utils/csrf";

export const fetchUserBills = async () => {
    const response = await fetch("/api/v1/user_bills")
    return await response.json()
}

export const userSaveBill = async (bill) => {

    console.log(bill);
    try {
        const response = await fetch("/api/v1/user_bills", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": csrfToken
            },
            body: JSON.stringify({
                    package_id: bill.package_id,
                }
            )
        })

        if (!response.ok) {
            throw new Error(`HTTP error saving bill: ${response.status}`)
        }
        const result = await response.json();
    } catch (e) {
        console.error("Error saving bill: ", e)
    }
}