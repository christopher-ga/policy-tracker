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
            <div className="bill-wrapper">
                <section className="bill-info">
                    <p className="bill-number">{bill.bill_type.toUpperCase()
                    } {bill.bill_number}</p>
                    <p className="congress-number">118th Congress</p>
                    <p className="short-title">{bill.short_title}</p>
                    <p className="long-title">{bill.title}</p>

                    <section className="sub-info">
                        <p>Latest Updates</p>
                        <p>{bill.latest_action_text}</p>
                        <p>{bill.latest_action_date}</p>
                    </section>

                    <button className="track-btn btn-dark">TRACK BILL</button>
                    <button className="track-btn btn-dark">STOP TRACKING BILL</button>

                </section>

                <div className="image-wrapper">
                    <p className="sponsor-header">Primary Sponsors</p>

                    <section className="bill-sponsors">
                        <section className="bill-sponsor">
                            <img className="sponsor-image" src={bill.sponsors?.[0]?.image_url || "aoc.jpg"}  alt="temp"/>
                            <p>{bill.sponsors?.[0]?.first_name || "err"} {bill.sponsors?.[0]?.last_name || "err"} </p>
                        </section>
                    </section>
                </div>
            </div>
        </>
    )
}

export default BillBannerComponent

