import React, {useEffect, useState} from "react"
import {stopTracking, userSaveBill} from "../services/billService";


const BillBannerComponent = ({bill}) => {

    const [isSaved, setIsSaved] = useState(() => bill.saved)

    useEffect(() => {
        setIsSaved(bill.saved);
    }, [bill]);

    const handleBillClick = () => {
        window.location.href = `/api/v1/bills/${bill.package_id}`;
    }

    const handleSaveBill = async (e) => {
        e.stopPropagation()
        await userSaveBill(bill);
        setIsSaved(true)
    }

    const stopTrackingBill = async (e) => {
        e.stopPropagation()
        await stopTracking(bill);
        setIsSaved(false);
        bill.changed = false
    }

    const dateUpdated = new Date(bill.update_date).toLocaleDateString("en-US");
    const actionDate = new Date(bill.latest_action_date).toLocaleDateString("en-US");
    console.log(bill);
    console.log(bill.changed)

    return (
        <>
            <div onClick={handleBillClick} className={`bill-wrapper ${bill.changed ? 'bill-update' : ""}`}>
                <section className="bill-info">
                    <div className="bill-number-date">
                        <p className="bill-number">{bill.bill_type.toUpperCase()
                        } {bill.bill_number}</p>
                        <p>Text Updated: {dateUpdated}</p>
                    </div>

                    <p className="congress-number">118th Congress</p>
                    <p className="short-title">{bill.short_title}</p>
                    <p className="long-title">{bill.title}</p>

                    <section className="sub-info">
                        <p>Latest Action: {actionDate} </p>
                        <p className="truncate">{bill.latest_action_text}</p>
                    </section>

                    {isSaved ? (<button onClick={stopTrackingBill} className="track-btn btn-dark">STOP TRACKING
                        BILL</button>) : (
                        <button onClick={handleSaveBill} className="track-btn btn-dark">TRACK BILL</button>)}

                    <p className="tracking-subscript">
                        {bill.tracking_count >= 2 ? (bill.tracking_count + " Other Users Tracking") : ("")}
                    </p>
                </section>

                <div className="image-wrapper">
                    <p className="sponsor-header">Primary Sponsor</p>
                    <section className="bill-sponsors">
                        <section className="bill-sponsor">
                            <img className="sponsor-image" src={bill.sponsors?.[0]?.image_url || "aoc.jpg"} alt="temp"/>
                            <p>{bill.sponsors?.[0]?.first_name || "err"} {bill.sponsors?.[0]?.last_name || "err"} </p>
                            <p>{bill.sponsors?.[0]?.party || "err"} - {bill.sponsors?.[0]?.state || "err"}</p>
                        </section>
                    </section>
                </div>
            </div>
        </>
    )
}

export default BillBannerComponent

