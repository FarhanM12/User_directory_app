# User Directory · Flutter Demo

A sleek Flutter app that fetches users from the **ReqRes** public API, shows
them in a glass-morphism list, and displays full details on tap.  
Built as a 48-hour take-home assignment.

---

## ✨ Highlights
| Feature | Details |
|---------|---------|
| Animated splash | Custom `CustomPainter` waves + glass panel. |
| Consistent design | Gradient + blur palette reused on every screen. |
| Pull-to-refresh & infinite scroll | Provider-driven paging spinner. |
| Hero transitions | Avatar morphs from list to detail. |
| Network-robust | DNS failover **and** offline JSON fallback, so the UI always loads—even on locked-down Wi-Fi. |

---

## 🔌 API & Backend Handling

1. **Primary call**   `https://reqres.in/api/users?page=n`  
2. **DNS failover**   If host lookup fails the app retries `https://104.26.11.213/api/users?page=n`
   with `Host: reqres.in` (bypasses DNS).  
3. **Proxy 401 fallback**   If a corporate proxy rewrites the response and
   returns `{"error":"Missing API key"}`, page 1 loads from
   **`assets/reqres_page1.json`** so reviewers still see data offline.  
4. Logic isolated in **`ApiService`** → UI only deals with `(users, totalPages)`.

---

## 🖼️ UI Choices & Architecture
* **Provider** for lightweight state (`UserProvider`).
* Record tuple `(List<User>, int)` to pass data + pagination info.
* Immutable **`User`** model (`fromJson`, `fullName` getter).
* Reusable *GlassCard* container for splash panel & list rows.
* Impeller/Vulkan backend enabled.

<details>
<summary>Folder structure</summary>

