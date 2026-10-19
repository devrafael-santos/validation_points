import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["column", "count"];

  dragStart(event) {
    this.draggedCard = event.currentTarget;
    this.originColumn = this.draggedCard.closest(
      "[data-kanban-target='column']",
    );
    this.draggedCard.classList.add("opacity-50");
    event.dataTransfer.effectAllowed = "move";
    event.dataTransfer.setData("text/plain", this.draggedCard.dataset.taskId);
  }

  dragEnd() {
    if (this.draggedCard) {
      this.draggedCard.classList.remove("opacity-50");
    }
    this.columnTargets.forEach((col) =>
      col.classList.remove("kanban-drop-active"),
    );
  }

  dragOver(event) {
    const column = event.currentTarget;
    if (column === this.originColumn) return;

    event.preventDefault();
    event.dataTransfer.dropEffect = "move";
    column.classList.add("kanban-drop-active");
  }

  dragLeave(event) {
    const column = event.currentTarget;
    if (!column.contains(event.relatedTarget)) {
      column.classList.remove("kanban-drop-active");
    }
  }

  async drop(event) {
    event.preventDefault();
    const targetColumn = event.currentTarget;
    targetColumn.classList.remove("kanban-drop-active");

    if (
      !this.draggedCard ||
      !this.originColumn ||
      targetColumn === this.originColumn
    ) {
      return;
    }

    const taskId = this.draggedCard.dataset.taskId;
    const newStage = targetColumn.dataset.stage;

    this.insertByPriority(targetColumn, this.draggedCard);
    this.updateCounts();

    const csrfToken = document.querySelector(
      "meta[name='csrf-token']",
    )?.content;

    try {
      const response = await fetch(`/tasks/${taskId}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
          Accept: "application/json",
        },
        body: JSON.stringify({ task: { stage: newStage } }),
      });

      if (!response.ok) {
        this.insertByPriority(this.originColumn, this.draggedCard);
        this.updateCounts();
      }
    } catch {
      this.insertByPriority(this.originColumn, this.draggedCard);
      this.updateCounts();
    }
  }

  insertByPriority(column, card) {
    const cardPriority = Number(card.dataset.priorityValue || 0);
    const existingCards = Array.from(column.querySelectorAll("[data-task-id]"));
    const lowerPriorityCard = existingCards.find(
      (existing) => Number(existing.dataset.priorityValue || 0) < cardPriority,
    );

    if (lowerPriorityCard) {
      column.insertBefore(card, lowerPriorityCard);
    } else {
      column.appendChild(card);
    }
  }

  updateCounts() {
    this.columnTargets.forEach((column) => {
      const stage = column.dataset.stage;
      const countBadge = this.countTargets.find(
        (badge) => badge.dataset.stage === stage,
      );
      if (countBadge) {
        countBadge.textContent =
          column.querySelectorAll("[data-task-id]").length;
      }
    });
  }
}
