import React, {useState} from "react";
import {csrfToken} from "../utils/csrf";

const SearchComponent = ({setBills, isLoading}) => {

    const [searchTerms, setSearchTerms] = useState('')
    const [sortOrder, setSortOrder] = useState('DESC');

    const handleSearch = async () => {
        isLoading(true)
        const bills = await fetch("api/v1/bills/search", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": csrfToken
            },
            body: JSON.stringify({ searchTerms, sortOrder })
        })
        const data = await bills.json();

        setBills(data)
        isLoading(false);
    }

    const handleSearchTerms = (e) => setSearchTerms(e.target.value);
    const handleSortChange = (e) => setSortOrder(e.target.value);


    return (
        <>
            <div className="search-container">
                <input type="text"
                       value={searchTerms}
                       className="search-bar"
                       onChange={handleSearchTerms}
                />


                <select value={sortOrder} onChange={handleSortChange} className="sort-dropdown">
                    <option value="DESC">New to Old</option>
                    <option value="ASC">Old to New</option>
                </select>
                <button onClick={handleSearch} className="search-btn">Search</button>

            </div>
        </>
    )
}

export default SearchComponent