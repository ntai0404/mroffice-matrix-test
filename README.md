# MROffice Build & Test Bridge (`matrix-ubuntu-dev`)

Repository trung gian phục vụ task **Build và test MrOffice** (`d66f0183-0a36-4ebf-be51-0de6ac5b4fd4` — dự án `CARA-SeABank-Agents-TotrinhKHDN`) trên máy **`matrix-ubuntu-dev` (`100.105.140.94`)** và đồng bộ kết quả nghiệm thu về máy Windows để nộp lên MIS.

## 5 Checklist Nghiệm Thu trên MIS

1. **Checklist 1:** Khảo sát môi trường `vsmac matrix ubuntu` (Node.js `>= 20.19`, npm, RAM/CPU), clone repo `XinaTian/MROffice` nhánh `main` và xác nhận mã commit `HEAD`.
2. **Checklist 2:** Cài đặt dependencies (`npm ci`), kiểm tra bản quyền third-party notices và tải bộ font thay thế Office (`npm run fonts`).
3. **Checklist 3:** Build bộ Web Editors & Playground của MROffice (`NODE_OPTIONS="--max-old-space-size=8192" npm run build`) và xác nhận tạo thành công gói build tĩnh.
4. **Checklist 4:** Chạy kiểm thử Smoke Test tự động (`node scripts/smoke.mjs` — mở, chỉnh sửa, lưu và mở lại tài liệu trên các trình soạn thảo Word, Excel, PowerPoint, PDF, Code) và bộ unit test/typecheck của `apps/desktop`.
5. **Checklist 5:** Khởi chạy kiểm tra dịch vụ Web Playground (`npm run preview`), tổng hợp toàn bộ log build & kết quả kiểm thử để nộp báo cáo nghiệm thu.

---

## Hướng dẫn cho AI Agent trên `matrix-ubuntu-dev`

Chạy tự động toàn bộ 5 bước và đẩy kết quả nghiệm thu về repo này:

```bash
git clone https://github.com/ntai0404/mroffice-matrix-test.git
cd mroffice-matrix-test
bash run-mroffice-test.sh
git add reports/
git commit -m "test: add MROffice build and smoke test report from matrix-ubuntu-dev"
git push origin main
```
