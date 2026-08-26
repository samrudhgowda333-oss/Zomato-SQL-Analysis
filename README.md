# Zomato SQL Analysis

## 1. Project Overview
Zomato's restaurant listings hold thousands of data points on pricing, cuisine, location, service options, and customer ratings — but on their own, they're just rows in a table. This project uses SQL to analyze **10,000+ Zomato restaurant records across Indian cities**, filtering the global dataset down to India (`Country_Code = 1`), to answer the questions a restaurant owner, food-delivery strategist, or diner would actually want answered: *where are restaurants concentrated, what drives higher ratings, and where does the best value dining actually exist?*

Using Oracle SQL, I queried and segmented restaurant data across city, cuisine, price tier, table-booking availability, online-delivery adoption, and vote volume to build a clear, evidence-based picture of the Indian restaurant market on Zomato.

## 2. Business Questions
This analysis was designed to answer eight practical questions about the Indian restaurant market:

1. Which cities in India have the most restaurants?
2. What are the most popular cuisines in India, and how do they rate?
3. Which cities have the highest online-delivery adoption?
4. Does offering table booking correlate with higher ratings?
5. Does a higher price range actually mean a better-rated restaurant?
6. Which restaurants offer the best value — high rating, low cost, high votes?
7. Which city has the most "Excellent" rated restaurants?
8. Do restaurants with more votes tend to have higher ratings?

## 3. Dataset
The analysis runs on a `zomato` table containing restaurant-level records with the following fields:

- **Identity & location:** Restaurant_ID, Restaurant_Name, Country_Code, City, Address
- **Offering:** Cuisines, Average_Cost_for_two, Currency
- **Service options:** Has_Table_booking, Has_Online_delivery
- **Performance:** Aggregate_rating, Rating_text, Votes

All analysis is scoped to India (`Country_Code = 1`), since that's where the overwhelming majority of listings and city-level detail live.

## 4. Tools & Technologies
- **Oracle SQL** — data querying, aggregation, and segmentation
- **SQL techniques used:** `CASE WHEN` bucketing (price tiers, vote tiers), conditional aggregation (`SUM(CASE WHEN...)`), `GROUP BY` with derived categories, `ROUND()` for rates and percentages, `HAVING` for minimum-sample filtering, multi-column filtering with `ORDER BY`/`LIMIT` for top-N and best-value queries

## 5. SQL Analysis
The analysis was structured in three progressive stages:

**Stage 1 — Baseline Distribution**
Checked the overall `Rating_text` distribution for India to understand how ratings are spread before slicing by any other dimension.

**Stage 2 — Single-Factor Analysis**
Queried restaurant counts and average ratings broken out by one variable at a time:
- City (restaurant density)
- Cuisine (popularity and rating)
- Online delivery adoption by city (with a `HAVING COUNT(*) > 50` floor to avoid small-sample noise)
- Table booking availability (Yes/No)
- Price category (Budget / Mid / Premium / Fine Dining, via `CASE WHEN` bucketing on `Average_Cost_for_two`)
- Vote volume (Low / Medium / High / Very High, via `CASE WHEN` bucketing on `Votes`)

**Stage 3 — Targeted & Ranked Analysis**
Combined rating, cost, and vote thresholds in a single filtered, ranked query to surface the actual best-value restaurants (Q6), and ranked cities by count of "Excellent"-rated restaurants specifically (Q7).

## 6. Key Findings

**1. City with the highest restaurant density**
**New Delhi** dominates the Indian market with **5,473 restaurants** — nearly **5x** Gurgaon (1,118) and Noida (1,080), the next-closest cities. Restaurant presence drops off sharply after the top three metro-adjacent cities (Faridabad at 251, then a long tail of cities in the 20s).

**2. Most popular cuisine**
**North Indian** is the single most common cuisine listing (936 restaurants), with **North Indian + Chinese** fusion the second most common combination (511) — reflecting how often Indian restaurants list multi-cuisine menus rather than a single specialty. Fast Food (348) and Chinese (340) round out the top standalone categories.

**3. Does online delivery adoption vary by city?**
Significantly. Among cities with enough restaurants to compare fairly (50+), **Gurgaon leads at 38% delivery adoption**, followed by Noida (33.7%) and New Delhi (27.2%) — despite New Delhi having by far the most restaurants overall. **Faridabad trails at just 13.9%**, suggesting delivery infrastructure/adoption hasn't scaled with restaurant count in every city.

**4. Does table booking correlate with higher ratings?**
Yes, clearly. Restaurants offering table booking average a **3.55 rating** versus **3.31** for those that don't — and they also pull in **more than double the average votes** (362 vs. 147). Table booking appears to be a marker of a more established, higher-engagement restaurant rather than just a convenience feature.

**5. Does a higher price mean a better rating?**
Directionally yes, but the effect is modest at the low end. Average ratings rise with price tier — **3.22** (under ₹300) → **3.25** (₹300–700) → **3.57** (₹700–1,500) → **3.74** (₹1,500+) — but the jump from Budget to Mid-range is small, while the jump into Premium and Fine Dining is much larger. Vote counts follow the same pattern, with Fine Dining restaurants pulling **541 average votes** versus just **54** for budget spots — price correlates with both quality *and* visibility.

**6. Do more votes mean a higher rating?**
Strongly yes. Restaurants with **2,000+ votes average a 4.17 rating**, compared to just **3.16 for restaurants under 100 votes** — a full point higher. This is the sharpest correlation found in the entire analysis, though it likely reflects both genuine quality (better restaurants earn more repeat engagement) and selection bias (mediocre restaurants rarely accumulate large vote counts).

**7. Best value-for-money restaurants**
Filtering for rating ≥ 4.0, cost for two ≤ ₹500, and votes ≥ 200 surfaces a clear leaderboard topped by **Naturals Ice Cream** (New Delhi, 4.9 rating, 2,620 votes, ₹150 for two) and **Grandson of Tunday Kababi** (Lucknow, 4.9 rating, 1,057 votes, ₹300 for two). Ice cream and dessert chains feature disproportionately often in the top 20 — low cost-per-head combined with high repeat-visit volume makes them standout value performers.

**8. Which city has the most "Excellent" rated restaurants?**
**New Delhi again leads decisively with 28 Excellent-rated restaurants**, more than double Gurgaon's 12 and triple Bangalore's 9 — reinforcing that New Delhi isn't just the largest market by volume, it also produces the deepest bench of top-tier dining.

## 7. Conclusion
This analysis shows that the Indian restaurant market on Zomato is heavily concentrated — both in volume and in quality — around **New Delhi and the NCR region** (Gurgaon, Noida, Faridabad), which together account for the vast majority of listings and nearly all of the top-rated "Excellent" restaurants. Within that market, **votes and table booking are the strongest positive signals of a well-regarded restaurant**, price matters but mostly at the high end, and **online delivery adoption is uneven even among comparably sized cities**, suggesting an operational gap rather than a demand gap in lower-adoption markets like Faridabad. Value dining is real and findable — a handful of low-cost, high-rating, high-vote restaurants (led by dessert and regional-specialty spots) prove that price and quality aren't strictly linked in this market.

## 8. Business Recommendations

1. **Prioritize New Delhi and NCR for market entry or expansion**, since restaurant density, delivery infrastructure, and "Excellent"-tier competition are all concentrated there — but expect the highest competitive bar for standing out in ratings.

2. **Investigate the delivery adoption gap in Faridabad and similar lower-adoption cities.** With adoption at 13.9% versus 38% in Gurgaon despite meaningful restaurant counts, this looks like an infrastructure or onboarding gap Zomato (or a delivery-focused new entrant) could close.

3. **Treat table booking as a retention and rating lever, not just a convenience feature** — restaurants with it show materially higher ratings and more than double the engagement (votes), suggesting it's worth actively encouraging adoption among mid-tier restaurants.

4. **Don't assume higher prices guarantee better ratings.** The rating gain from Budget to Mid-range pricing is minimal (3.22 → 3.25); operators shouldn't raise prices expecting a rating lift unless they're also moving into the Premium/Fine Dining tier where the real jump happens.

5. **Use vote volume as an early-warning quality signal.** Restaurants under 100 votes average nearly a full point lower in rating than restaurants with 2,000+ — new or low-visibility restaurants may benefit from promotions that build vote volume, which correlates strongly with reputation.

6. **Highlight value-tier winners (like Naturals Ice Cream and Grandson of Tunday Kababi) in city guides or "best value" marketing pushes** — high-rating, low-cost, high-vote restaurants are a distinct and appealing segment that pure price or pure rating filters would miss on their own.

---
*Analysis performed using Oracle SQL. Full query file: `zomato_deep_dive_project.sql`*
