import React, {useState} from "react";
import {csrfToken} from "../utils/csrf";

const SearchComponent = ({setBills}) => {

    const [searchTerms, setSearchTerms] = useState('')

    const handleSearch = async () => {
        const bills = await fetch("api/v1/bills/search", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": csrfToken
            },
            body: JSON.stringify({searchTerms})
        })
        const data = await bills.json();

        console.log(data);
        setBills(data)
    }

    const handleSearchTerms = (e) => {
        setSearchTerms(e.target.value);
    };

    return (
        <>
            <div className="search-container">
                <input type="text"
                       value={searchTerms}
                       className="search-bar"
                       onChange={handleSearchTerms}
                />
                <button onClick={handleSearch} className="search-btn">Search</button>
            </div>
        </>
    )
}

export default SearchComponent