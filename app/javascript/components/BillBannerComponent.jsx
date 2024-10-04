import React, {useEffect, useState} from "react"

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

const BillBannerComponent = ({bill}) => {
    const handleSaveBill = async () => {
        const response = await fetch('/bills', {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": csrfToken
            },
            body: JSON.stringify({
                bill: {
                    title: bill.title,
                    bill_id: bill.number,
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
        });

        const result = await response.json();

        if (result.status === "success") {
            console.log("bill saved", result.bill);
        } else {
            console.log("Error saving bill", result.message);
        }
    }


    return (
        <>
            <div>
                <p>{bill.title}</p>
            </div>

            <div>
                <h2>sponsors</h2>
                <p>{bill.sponsorFirstName}</p>
            </div>

            <button onClick={handleSaveBill}>
                Save Bill
            </button>
        </>
    )
}

export default BillBannerComponent