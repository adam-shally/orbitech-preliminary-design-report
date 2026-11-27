import os
import textwrap
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches

os.makedirs("figures", exist_ok=True)

# OrbiTech Corporate & Academic Palette
NAVY = "#0F294A"
BLUE = "#1D5B9E"
CYAN = "#00A3E0"
TEAL = "#16A085"
GOLD = "#D99B26"
RED = "#C0392B"
GREEN = "#27AE60"
ORANGE = "#E67E22"
LIGHT_BG = "#F8FAFC"
BORDER_GRAY = "#CBD5E1"
TEXT_DARK = "#1E293B"
GRAY = "#64748B"

plt.rcParams["font.sans-serif"] = "DejaVu Sans"
plt.rcParams["axes.edgecolor"] = BORDER_GRAY
plt.rcParams["axes.linewidth"] = 1.0

DPI = 300

def save_fig(fig, filename):
    path = os.path.join("figures", filename)
    fig.savefig(path, dpi=DPI, bbox_inches="tight", pad_inches=0.15, facecolor="white")
    plt.close(fig)
    print(f"Saved: {path}")

def draw_box(ax, x, y, w, h, text, facecolor=NAVY, edgecolor="none", textcolor="white", fontsize=8.2, bold=True, alpha=1.0):
    box = patches.FancyBboxPatch(
        (x - w / 2, y - h / 2), w, h,
        boxstyle="round,pad=0.03,rounding_size=0.05",
        facecolor=facecolor, edgecolor=edgecolor, linewidth=1.2, alpha=alpha
    )
    ax.add_patch(box)
    max_chars = max(14, int(w * 15))
    wrapped_lines = []
    for line in text.split("\n"):
        wrapped_lines.extend(textwrap.wrap(line, width=max_chars))
    wrapped_text = "\n".join(wrapped_lines)
    ax.text(
        x, y, wrapped_text, ha="center", va="center", color=textcolor,
        fontsize=fontsize, fontweight="bold" if bold else "normal"
    )

# 1. Intro Funnel (Chapter 1 - Aligned with Section 1.1-1.3)
def make_intro_funnel():
    fig, ax = plt.subplots(figsize=(11.5, 7.0))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6.2)
    ax.axis("off")

    levels = [
        (5.2, 9.4, NAVY, "1. Macro KM & AI Trends:\nGrounded RAG, Source Traceability & Version-Controlled Generation"),
        (3.8, 8.4, BLUE, "2. Applied Context (IAI Reference):\nPreserving Tacit SME Judgment & Approved Unclassified Procedures"),
        (2.4, 7.4, CYAN, "3. Engineering Design Targets (Pre-Pilot):\nCut Unit Prep Time >=50% with >=90% Factual Faithfulness"),
        (1.0, 6.4, TEAL, "4. OrbiTech Academic Pilot (14 Weeks):\nLocal Grounded RAG + 1 Generic 3D Scenario (Public FAA Corpus)"),
    ]
    for y, w, col, label in levels:
        draw_box(ax, 5.0, y, w, 0.95, label, facecolor=col, fontsize=8.5)
        if y > 1.2:
            ax.annotate("", xy=(5.0, y - 0.72), xytext=(5.0, y - 0.22),
                        arrowprops=dict(arrowstyle="-|>", color=NAVY, lw=2.0, mutation_scale=12))

    ax.text(5.0, 0.2, "*Design targets and pilot scope (not measured organizational claims; public FAA-H-8083-30B corpus).",
            ha="center", va="center", fontsize=7.2, style="italic", color=GRAY)
    save_fig(fig, "intro_funnel.png")

# 2. MECE Issue Tree (Chapter 2.3 - Aligned 100% with Figure 2.1 on p. 4)
def make_issue_tree():
    fig, ax = plt.subplots(figsize=(13.5, 8.2))
    ax.set_xlim(0, 11.2)
    ax.set_ylim(0, 7.2)
    ax.axis("off")

    draw_box(ax, 1.5, 3.6, 2.7, 2.1,
             "Core Research Question:\nHow can local Grounded RAG\n+ 3D scenario practice cut unit\nprep time >=50% while keeping\n>=90% faithfulness & air-gapped\nsecurity?",
             facecolor=NAVY, fontsize=7.8)

    branches = [
        (5.7, "1. Knowledge & Sources\n(Mapping, Versions, Access)", BLUE, [
            (6.4, "1.1 Which approved sources & records exist?"),
            (5.0, "1.2 Which document revision is valid & permitted?")
        ]),
        (3.6, "2. Training Generation\n(Retrieval, Control, Quality)", CYAN, [
            (4.3, "2.1 Is every claim grounded in a cited source?"),
            (2.9, "2.2 How much prep time is saved vs. manual?")
        ]),
        (1.5, "3. Learning & Verification\n(Exam, 3D Practice, Feedback)", TEAL, [
            (2.2, "3.1 Did the trainee understand & pass rubric?"),
            (0.8, "3.2 What decisions & timings were logged in 3D?")
        ]),
    ]

    for by, btitle, col, leaves in branches:
        draw_box(ax, 4.6, by, 2.4, 1.0, btitle, facecolor=col, fontsize=8.0)
        ax.plot([2.85, 3.4], [3.6, by], color=NAVY, lw=1.5)
        for ly, ltext in leaves:
            draw_box(ax, 8.6, ly, 4.5, 0.9, ltext, facecolor=LIGHT_BG, edgecolor=col, textcolor=TEXT_DARK, fontsize=7.8, bold=False)
            ax.plot([5.8, 6.35], [by, ly], color=col, lw=1.2)

    save_fig(fig, "issue_tree.png")

# 3. System Architecture (Chapter 6.1-6.4 - Aligned with Lifecycle & Security Constraints)
def make_system_architecture():
    fig, ax = plt.subplots(figsize=(13.5, 8.8))
    ax.set_xlim(0, 10.6)
    ax.set_ylim(0, 7.8)
    ax.axis("off")

    stages = [
        (1.5, 2.5, "#EBF3FA", BLUE, "INPUT LAYER\n(Approved Unclassified Sources)"),
        (5.3, 4.0, "#E8F8F5", TEAL, "ORBITECH LOCAL ENGINE\n(Air-Gapped On-Premise Core)"),
        (9.1, 2.5, "#FEF9E7", GOLD, "OUTPUT LAYER\n(Verified Training & Logs)"),
    ]
    for sx, sw, bg, ec, title in stages:
        rect = patches.FancyBboxPatch((sx - sw / 2, 0.4), sw, 6.9, boxstyle="round,pad=0.03,rounding_size=0.06",
                                      facecolor=bg, edgecolor=ec, linewidth=1.5)
        ax.add_patch(rect)
        ax.text(sx, 7.05, title, ha="center", va="center", color=NAVY, fontsize=9.0, fontweight="bold")

    for y, lbl in [
        (5.7, "Public / Approved Docs\n(FAA-H-8083-30B)"),
        (3.9, "Versioned Tables &\nSection Metadata"),
        (2.1, "SME Interviews\n(3D What-if Notes)")
    ]:
        draw_box(ax, 1.5, y, 2.2, 1.15, lbl, facecolor=BLUE, fontsize=7.8)

    draw_box(ax, 5.3, 5.8, 3.5, 1.0, "1.0 Ingestion & Version Tagging\n(doc_id, revision, page, access)", facecolor=NAVY, fontsize=7.8)
    draw_box(ax, 5.3, 4.3, 3.5, 1.0, "2.0 Hybrid RAG + Local LLM\n(Citation Guardrails & Abstention)", facecolor=BLUE, fontsize=7.8)
    draw_box(ax, 5.3, 2.8, 3.5, 1.0, "3.0 3D Scenario (3 Nodes) &\nParallel 2D Track Generator", facecolor=CYAN, fontsize=7.8)
    draw_box(ax, 5.3, 1.3, 3.5, 1.0, "4.0 HITL SME Approval Gate\n& Version Revocation Control", facecolor=RED, fontsize=7.8)

    for y, lbl in [
        (5.7, "Approved Units &\nCompetency Quizzes"),
        (3.9, "Interactive 3D Scene\n+ 2D Equivalent Track"),
        (2.1, "Source-Cited Feedback\n& Telemetry Logs")
    ]:
        draw_box(ax, 9.1, y, 2.2, 1.15, lbl, facecolor=NAVY, fontsize=7.8)

    ax.annotate("", xy=(3.3, 3.9), xytext=(2.75, 3.9), arrowprops=dict(arrowstyle="-|>", color=NAVY, lw=2.0, mutation_scale=12))
    ax.annotate("", xy=(7.85, 3.9), xytext=(7.3, 3.9), arrowprops=dict(arrowstyle="-|>", color=NAVY, lw=2.0, mutation_scale=12))

    ax.text(5.3, 0.12, "*Zero outbound network calls during experiment; simulated stress exercises are digital-only with prior consent.",
            ha="center", va="center", fontsize=7.0, style="italic", color=GRAY)
    save_fig(fig, "system_architecture.png")

# 4. Market Layers TAM/SAM/SOM (Chapter 4.2 - Aligned 100% with Table 4.1 on p. 11)
def make_market_layers():
    fig, ax = plt.subplots(figsize=(10.5, 8.8))
    ax.set_aspect("equal")
    ax.set_xlim(-0.5, 11.5)
    ax.set_ylim(-0.6, 9.2)
    ax.axis("off")

    circles = [
        (3.0, 4.5, 3.2, NAVY, "TAM\n$20.1B"),
        (3.0, 3.8, 2.3, BLUE, "SAM Proxy\n$15.23B"),
        (3.0, 3.0, 1.3, CYAN, "SOM Scenario\n$1.52M"),
    ]
    for cx, cy, r, col, lbl in circles:
        c = patches.Circle((cx, cy), r, facecolor=col, edgecolor="white", linewidth=1.5, alpha=0.95)
        ax.add_patch(c)
        ty = cy + r - 0.50 if r > 1.5 else cy
        ax.text(cx, ty, lbl, ha="center", va="center", color="white", fontsize=9.2, fontweight="bold")

    descriptions = [
        (7.4, NAVY, "TAM ($20.1B - Analyst Report [22]):\nGlobal Knowledge Management Software &\nServices Market (2024; $25.0B est. 2026)"),
        (4.5, BLUE, "SAM Proxy ($15.23B = $20.1B x 75.76%):\nGlobal KM Software Segment Upper Bound\n(Not proven defense-accessible market)"),
        (1.6, CYAN, "SOM Scenario ($1.52M = 0.01% of SAM Proxy):\nIllustrative Order-of-Magnitude Check Only\n(Not an academic pilot sales forecast)"),
    ]
    for dy, col, txt in descriptions:
        draw_box(ax, 8.8, dy, 4.6, 1.45, txt, facecolor=LIGHT_BG, edgecolor=col, textcolor=TEXT_DARK, fontsize=7.6, bold=False)

    ax.text(5.5, -0.3, "*Source: Grand View Research (2024) [22] & Table 4.1 methodology; SAM proxy and SOM are transparent analytical bounds.",
            ha="center", va="center", fontsize=7.0, style="italic", color=GRAY)
    save_fig(fig, "market_layers.png")

# 5. Benchmark Rubric Radar (Chapter 4.4 - Aligned with Table 4.3; No Unmeasured Vendor Scores)
def make_radar_chart():
    categories = [
        "Production Time\n(<=50% of Manual)",
        "Source Faithfulness\n(>=90% Supported)",
        "Version Governance\n(0 Outdated Items)",
        "Air-Gap Isolation\n(0 Outbound Calls)",
        "Pedagogical Quality\n(>=80% Rubric Pass)",
        "Total Pilot Cost\n(Local Open Stack)"
    ]
    N = len(categories)
    angles = np.linspace(0, 2 * np.pi, N, endpoint=False).tolist()
    angles += angles[:1]

    # Pre-measurement target rubric (0-5 scale per Table 4.3)
    data = {
        "OrbiTech Design Target (REQ Thresholds)": ([4.5, 4.5, 5.0, 5.0, 4.0, 4.0], CYAN, "-"),
        "Minimum Go/No-Go Acceptance Gate": ([3.5, 4.0, 4.5, 5.0, 3.5, 3.0], GOLD, "--"),
    }

    fig = plt.figure(figsize=(10.0, 9.5))
    ax = fig.add_subplot(111, polar=True)
    ax.set_theta_offset(np.pi / 2)
    ax.set_theta_direction(-1)

    for label, (vals, col, ls) in data.items():
        v = vals + vals[:1]
        ax.plot(angles, v, linewidth=2.2, linestyle=ls, label=label, color=col)
        if "Design Target" in label:
            ax.fill(angles, v, color=col, alpha=0.14)

    ax.set_xticks(angles[:-1])
    ax.set_xticklabels(categories, fontsize=8.5, color=TEXT_DARK, fontweight="bold")
    ax.tick_params(pad=26)
    ax.set_ylim(0, 5.2)
    ax.set_yticks([1, 2, 3, 4, 5])
    ax.set_yticklabels(["1", "2", "3", "4", "5"], fontsize=7.5, color=GRAY)

    ax.legend(loc="upper center", bbox_to_anchor=(0.5, -0.14), ncol=1, fontsize=8.5, frameon=True)
    ax.set_title("6-Axis Benchmark Evaluation Rubric (0-5 Scale)\nDesign Targets Only — Competitor Scores Pending Demo Run (Table 4.3)",
                 fontsize=9.8, fontweight="bold", color=NAVY, pad=26)

    save_fig(fig, "radar_chart.png")

# 6. Controlled Benchmark & Target Frontier (Chapter 4.5 - Aligned with Table 4.4; No Fake Vendor Prices)
def make_scatter_cost_perf():
    fig, ax = plt.subplots(figsize=(10.5, 6.5))

    # Plot Design Target Space vs. Manual Baseline (Normalized %)
    points = [
        ("Manual Baseline\n(100% Prep Time, Reference)", 100, 75, GRAY, 150, (-10, -24)),
        ("OrbiTech Pilot Target\n(<=50% Time, >=90% Faithfulness)", 50, 90, CYAN, 200, (12, -6)),
        ("Stretch Target\n(35% Time, 95% Faithfulness)", 35, 95, TEAL, 130, (12, 6)),
    ]

    for name, time_pct, faith_pct, col, sz, offset in points:
        ax.scatter(time_pct, faith_pct, s=sz, color=col, edgecolors=NAVY, linewidth=1.2, zorder=5)
        ax.annotate(name, (time_pct, faith_pct), xytext=offset, textcoords="offset points",
                    fontsize=8.2, fontweight="bold" if "OrbiTech" in name else "normal", color=TEXT_DARK)

    # Target acceptance zone: Time <= 50%, Faithfulness >= 90%
    rect = patches.Rectangle((15, 90), 35, 10, facecolor=GREEN, alpha=0.10, edgecolor=GREEN, linestyle="--", lw=1.2,
                             label="REQ-03 & REQ-04 Acceptance Zone (Time <=50%, Faithfulness >=90%)")
    ax.add_patch(rect)

    ax.annotate("", xy=(52, 89), xytext=(98, 76),
                arrowprops=dict(arrowstyle="-|>", color=BLUE, lw=1.6, linestyle="--", mutation_scale=12))
    ax.text(76, 80, "5-Step Controlled Benchmark\n(20-Item Test Suite, Table 4.4)", fontsize=7.6, color=BLUE, ha="center", fontweight="bold")

    ax.set_xlim(15, 115)
    ax.set_ylim(60, 102)
    ax.set_xlabel("Median Unit Preparation Time (% of Manual Baseline — Lower is Better)", fontsize=8.8, color=NAVY, fontweight="bold")
    ax.set_ylabel("Supported Factual Faithfulness (% — Higher is Better)", fontsize=8.8, color=NAVY, fontweight="bold")
    ax.tick_params(labelsize=8.0)
    ax.grid(True, linestyle="--", alpha=0.35, zorder=1)
    ax.legend(loc="lower left", fontsize=7.8, frameon=True)
    ax.set_title("Controlled Benchmark Target Space (Pre-Measurement Design Thresholds, Table 4.4)",
                 fontsize=9.6, fontweight="bold", color=NAVY, pad=12)

    save_fig(fig, "scatter_cost_perf.png")

# 7. Pugh Decision Matrix (Chapter 5.2 - Aligned 100% with Table 5.1 & Figure 5.1 on pp. 14-15)
def make_pugh_scores():
    alternatives = [
        "Alt A: Manual Baseline\n(Word/Excel/PPT & Interviews)",
        "Alt B: Digital LMS & Search\n(No RAG Generation)",
        "Alt C: OrbiTech Proposed\n(Local RAG + HITL + 3D)"
    ]
    # Exact scores from Table 5.1 (weight * rating)
    criteria = [
        ("Faithfulness & Control (0.25)", [1.00, 0.75, 1.25], NAVY),
        ("Security & Local Control (0.25)", [1.25, 0.75, 1.00], BLUE),
        ("Prep Time Savings (0.20)", [0.20, 0.40, 1.00], CYAN),
        ("Ease of Implementation (0.15)", [0.75, 0.60, 0.30], TEAL),
        ("Version Management (0.15)", [0.30, 0.60, 0.75], GOLD),
    ]

    fig, ax = plt.subplots(figsize=(12.0, 6.5))
    fig.subplots_adjust(left=0.35)

    y_pos = np.arange(len(alternatives))
    left = np.zeros(len(alternatives))

    for cname, scores, col in criteria:
        arr = np.array(scores)
        ax.barh(y_pos, arr, left=left, height=0.48, color=col, edgecolor="white", label=cname, zorder=2)
        left += arr

    for idx, total in enumerate(left):
        ax.text(total + 0.08, y_pos[idx], f"{total:.2f}", va="center", fontsize=9.5, fontweight="bold", color=NAVY)

    ax.set_yticks(y_pos)
    ax.set_yticklabels(alternatives, fontsize=8.8, fontweight="bold", color=TEXT_DARK)
    ax.set_xlim(0, 5.2)
    ax.set_xlabel("Weighted Pugh Score (Max = 5.00; Design Assumptions Only, Table 5.1)", fontsize=9.0, color=NAVY, fontweight="bold")
    ax.tick_params(axis="x", labelsize=8.0)
    ax.grid(axis="x", linestyle="--", alpha=0.35, zorder=1)

    ax.legend(loc="upper center", bbox_to_anchor=(0.32, 1.24), ncol=2, fontsize=8.0, frameon=False)

    save_fig(fig, "pugh_scores.png")

# 8. Data Flow Diagram DFD (Chapter 6.3 - Aligned 100% with Text & Figure 6.1 on p. 17)
def make_dfd_diagram():
    fig, ax = plt.subplots(figsize=(13.5, 8.6))
    ax.set_xlim(0.4, 10.2)
    ax.set_ylim(0.2, 5.8)
    ax.axis("off")

    # Two human external entities per Section 6.3
    draw_box(ax, 1.5, 4.7, 2.0, 0.95, "External Entity 1:\nExpert / Knowledge Mgr", facecolor=NAVY, fontsize=7.8)
    draw_box(ax, 9.1, 2.9, 2.0, 1.0, "External Entity 2:\nTrainee / Learner", facecolor=NAVY, fontsize=7.8)

    # Processes
    draw_box(ax, 4.3, 4.7, 2.3, 0.9, "P1.0 Parsing & Indexing\n(Version, Page, Access)", facecolor=BLUE, fontsize=7.8)
    draw_box(ax, 4.3, 2.9, 2.3, 0.9, "P2.0 Hybrid RAG &\nEvidence Ranking", facecolor=CYAN, fontsize=7.8)
    draw_box(ax, 6.9, 2.9, 2.1, 0.9, "P3.0 Draft Unit, Quiz &\n3D Scenario Gen", facecolor=TEAL, fontsize=7.8)
    draw_box(ax, 4.3, 1.1, 2.3, 0.9, "P4.0 HITL SME Gate &\nVersion Revocation", facecolor=RED, fontsize=7.8)

    # Data Stores
    draw_box(ax, 6.9, 4.7, 2.1, 0.9, "D1 | Approved Docs &\nIndexed Chunks", facecolor=LIGHT_BG, edgecolor=NAVY, textcolor=TEXT_DARK, fontsize=7.8)
    draw_box(ax, 6.9, 1.1, 2.1, 0.9, "D2 | Approved Items &\nAudit/Telemetry Log", facecolor=LIGHT_BG, edgecolor=GOLD, textcolor=TEXT_DARK, fontsize=7.8)

    arrows = [
        ((2.5, 4.7), (3.15, 4.7), "Approved SOPs", 0.16),
        ((5.45, 4.7), (5.85, 4.7), "Chunks", 0.16),
        ((6.9, 4.25), (4.9, 3.35), "Permitted Rev", 0.18),
        ((5.45, 2.9), (5.85, 2.9), "Ranked Evid.", 0.16),
        ((6.9, 2.45), (4.8, 1.55), "Drafts", -0.22),
        ((1.5, 4.22), (3.15, 1.1), "SME Sign-off / Reject", -0.22),
        ((5.45, 1.1), (5.85, 1.1), "Approved", 0.16),
        ((7.95, 1.3), (8.5, 2.4), "3D / Quiz / Citations", -0.18),
        ((9.1, 2.4), (7.5, 1.55), "Choice & Time Logs", 0.18),
    ]
    for start, end, lbl, lbl_offset in arrows:
        ax.annotate("", xy=end, xytext=start, arrowprops=dict(arrowstyle="-|>", color=NAVY, lw=1.2, mutation_scale=10))
        mx, my = (start[0] + end[0]) / 2, (start[1] + end[1]) / 2
        ax.text(mx, my + lbl_offset, lbl, ha="center", va="center", fontsize=7.0, color=NAVY, fontweight="bold")

    save_fig(fig, "dfd_diagram.png")

# 9. Work Breakdown Structure WBS (Chapter 7.2 - Aligned 100% with Table 7.1 on p. 21: 6 WPs)
def make_wbs_diagram():
    fig, ax = plt.subplots(figsize=(15.5, 8.8))
    ax.set_xlim(0, 12.2)
    ax.set_ylim(-0.2, 5.4)
    ax.axis("off")

    draw_box(ax, 6.1, 4.95, 5.4, 0.65, "OrbiTech Project 5: Local Grounded RAG & 3D Training Pilot (14 Weeks)", facecolor=NAVY, fontsize=8.8)

    wps = [
        (1.1, "WP 1.0 (W1-W3)\nSpec & Corpus\n[Nachla]", BLUE, ["1.1 Baseline Qs", "1.2 Eval Rubric"]),
        (3.1, "WP 2.0 (W2-W5)\nLocal Arch\n[Adam]", CYAN, ["2.1 Tech Survey", "2.2 Air-Gap Block"]),
        (5.1, "WP 3.0 (W4-W7)\nIngest & Index\n[Adam]", TEAL, ["3.1 Doc Parsing", "3.2 Hybrid Search"]),
        (7.1, "WP 4.0 (W5-W10)\nEngine & 3D\n[Nachla]", GOLD, ["4.1 Content Gen", "4.2 SME Approval", "4.3 3D (3 Nodes)"]),
        (9.1, "WP 5.0 (W9-W12)\nTests & 2D/3D\n[Adam]", ORANGE, ["5.1 Manual vs RAG", "5.2 2D/3D & Fixes"]),
        (11.1, "WP 6.0 (W12-W14)\nReport & Demo\n[Nachla]", NAVY, ["6.1 Final Report", "6.2 Project Conf."]),
    ]

    ax.plot([1.1, 11.1], [4.32, 4.32], color=NAVY, lw=1.5)
    ax.plot([6.1, 6.1], [4.62, 4.32], color=NAVY, lw=1.5)

    for wx, wtitle, col, tasks in wps:
        ax.plot([wx, wx], [4.32, 3.98], color=NAVY, lw=1.5)
        draw_box(ax, wx, 3.45, 1.82, 1.0, wtitle, facecolor=col, fontsize=7.0)
        for idx, t in enumerate(tasks):
            ty = 2.2 - idx * 0.92
            draw_box(ax, wx, ty, 1.82, 0.72, t, facecolor=LIGHT_BG, edgecolor=col, textcolor=TEXT_DARK, fontsize=6.8, bold=False)

    save_fig(fig, "wbs_diagram.png")

# 10. Milestones Timeline (Chapter 7.4 - Aligned 100% with Table 7.3 on p. 22: M0-M6)
def make_milestones_timeline():
    fig, ax = plt.subplots(figsize=(14.0, 4.8))
    ax.set_xlim(0.2, 10.8)
    ax.set_ylim(-0.3, 4.4)
    ax.axis("off")

    ax.plot([0.5, 10.5], [1.8, 1.8], color=NAVY, lw=2.5, zorder=1)

    milestones = [
        (0.8, "M0 (W1)", "Pilot Kickoff &\nScope Defined", NAVY, True),
        (2.4, "M1 (W4)", "Public Corpus &\nTruth Qs Ready", BLUE, False),
        (4.0, "M2 (W5)", "Air-Gapped Arch\nDocumented", CYAN, True),
        (5.6, "M3 (W9)", "Alpha Prototype\n(Go/No-Go Gate)", RED, False),
        (7.2, "M4 (W11)", "Comparative\nPilot Run Done", TEAL, True),
        (8.8, "M5 (W13)", "Re-Validation &\nREQ Audit", GOLD, False),
        (10.2, "M6 (W14)", "Final Report &\n3D Demo Conf", GREEN, True),
    ]

    for mx, code, desc, col, above in milestones:
        ax.scatter(mx, 1.8, s=110, color=col, edgecolors="white", linewidth=2.0, zorder=3)
        y_box = 3.25 if above else 0.55
        y_line = 2.55 if above else 1.2
        ax.plot([mx, mx], [1.8, y_line], color=col, lw=1.5, linestyle="--")
        draw_box(ax, mx, y_box, 1.55, 1.05, f"{code}\n{desc}", facecolor=col, fontsize=6.8)

    save_fig(fig, "milestones_timeline.png")

# 11. Gantt Chart (Chapter 7.5 - Aligned 100% with Table 7.1, Table 7.4 & Figure 7.1 on pp. 21-23)
def make_gantt_chart():
    tasks = [
        ("WP1: Spec, Baseline & FAA Corpus [Nachla]", 1, 3, True),
        ("WP2: Local RAG Arch & Air-Gap [Adam]", 2, 4, True),
        ("WP3: Doc Ingestion & Version Index [Adam]", 4, 4, True),
        ("WP4.1-4.2: RAG Gen & SME Approval [Nachla]", 5, 5, True),
        ("WP4.3: 3D Script & Scene (3 Nodes) [Both]", 6, 4, True),
        ("WP5: Manual vs RAG & 2D/3D Tests [Adam]", 9, 4, True),
        ("WP6: Re-Validation, Report & Conf [Nachla]", 12, 3, True),
    ]

    fig, ax = plt.subplots(figsize=(12.5, 6.2))
    fig.subplots_adjust(left=0.36)

    y_pos = np.arange(len(tasks))[::-1]

    for idx, (name, start, dur, crit) in enumerate(tasks):
        col = NAVY if idx % 2 == 0 else TEAL
        ax.barh(y_pos[idx], dur, left=start - 0.5, height=0.52, color=col, edgecolor="none", alpha=0.92, zorder=2)

    # Milestones M0-M6 (Weeks 1, 4, 5, 9, 11, 13, 14 per Table 7.3)
    ms_weeks = [1, 4, 5, 9, 11, 13, 14]
    ms_labels = ["M0", "M1", "M2", "M3\n(Go/No-Go)", "M4", "M5", "M6"]
    for w, lbl in zip(ms_weeks, ms_labels):
        ax.axvline(w, color=RED if w == 9 else GOLD, linestyle="--", lw=1.1, zorder=1)
        ax.text(w, len(tasks) - 0.35, lbl, color=RED if w == 9 else NAVY, fontsize=7.2, fontweight="bold", ha="center")

    ax.set_yticks(y_pos)
    ax.set_yticklabels([t[0] for t in tasks], fontsize=8.2, color=TEXT_DARK, fontweight="bold")
    ax.set_xticks(range(1, 15))
    ax.set_xticklabels([f"W{w}" for w in range(1, 15)], fontsize=8.2, color=TEXT_DARK)
    ax.set_xlim(0.3, 14.7)
    ax.set_ylim(-0.7, len(tasks) + 0.3)
    ax.grid(axis="x", linestyle=":", alpha=0.45, zorder=1)
    ax.set_title("Semester B Academic Pilot Plan — 14 Weeks (Planning Schedule, Not Executed Results)",
                 fontsize=9.5, fontweight="bold", color=NAVY, pad=12)

    save_fig(fig, "gantt_chart.png")

# 12. 5x5 Risk Matrix (Chapter 8.2 - Aligned 100% with Table 8.1 & Figure 8.1 on pp. 24-25: R01-R12)
def make_risk_matrix():
    fig, ax = plt.subplots(figsize=(9.5, 7.8))

    for p in range(1, 6):
        for i in range(1, 6):
            r = p * i
            if r >= 12:
                col = "#FADBD8"
                tcol = RED
            elif r >= 5:
                col = "#FDEBD0"
                tcol = ORANGE
            else:
                col = "#D4EFDF"
                tcol = GREEN
            rect = patches.Rectangle((i - 0.5, p - 0.5), 1, 1, facecolor=col, edgecolor="white", linewidth=1.2)
            ax.add_patch(rect)
            ax.text(i + 0.38, p - 0.38, str(r), ha="center", va="center", fontsize=7.5, color=tcol, alpha=0.65)

    # Exact (Impact, Probability) cells for all 12 critical risks in Table 8.1 & Figure 8.1
    cells = [
        (5, 4, "R03 (R=20)\nUnsupported Content"),
        (5, 3, "R02 (R=15)\nData / Outbound Leak"),
        (4, 4, "R01, R04, R10, R11\n(R=16 Critical Cluster)"),
        (4, 3, "R06, R07, R08, R12\n(R=12 Ops & UI Cluster)"),
        (3, 4, "R05, R09 (R=12)\nTables & Sample Size"),
    ]

    for imp, prob, lbl in cells:
        ax.text(imp, prob + 0.05, lbl, ha="center", va="center", fontsize=7.2, fontweight="bold", color=TEXT_DARK,
                bbox=dict(boxstyle="round,pad=0.3", facecolor="white", edgecolor=RED, alpha=0.94, linewidth=1.0))

    ax.set_xlim(0.5, 5.5)
    ax.set_ylim(0.5, 5.5)
    ax.set_xticks(range(1, 6))
    ax.set_yticks(range(1, 6))
    ax.set_xlabel("Impact (I): 1 = Negligible  -->  5 = Catastrophic", fontsize=9.0, fontweight="bold", color=NAVY)
    ax.set_ylabel("Probability (P): 1 = Rare  -->  5 = Almost Certain", fontsize=9.0, fontweight="bold", color=NAVY)
    ax.set_title("5x5 Risk Assessment Matrix — Pre-Mitigation Design Scores (R = P x I >= 12, Table 8.1)",
                 fontsize=9.4, fontweight="bold", color=NAVY, pad=12)

    save_fig(fig, "risk_matrix.png")

if __name__ == "__main__":
    make_intro_funnel()
    make_issue_tree()
    make_system_architecture()
    make_market_layers()
    make_radar_chart()
    make_scatter_cost_perf()
    make_pugh_scores()
    make_dfd_diagram()
    make_wbs_diagram()
    make_milestones_timeline()
    make_gantt_chart()
    make_risk_matrix()
    print("\nAll 12 figures generated and 100% synchronized with main.pdf!")