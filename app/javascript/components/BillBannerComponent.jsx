import React, {useEffect, useState} from "react"
import {userSaveBill} from "../services/billService";

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

const BillBannerComponent = ({bill}) => {

    const [isSaved, setIsSaved] = useState(bill.saved)

    const handleSaveBill = async () => {
       await userSaveBill(bill);
    }


    return (
        <>
            <div>
                <p>{bill.title}</p>
            </div>

            {/*<div>*/}
            {/*    <h2>sponsors</h2>*/}
            {/*    <p>{bill.sponsorFirstName}</p>*/}
            {/*</div>*/}

            <button onClick={handleSaveBill}>
                {isSaved ? "Already Saved!" : "Save Bill"}
            </button>
        </>
    )
}

export default BillBannerComponent