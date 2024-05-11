import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["operations", "listingTypes"];

  submitForm() {
    const form = this.element.querySelector("form");
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      form.submit();
    }, 200);
  }

  async fetchOperationsAndListingTypes(event) {
    console.log("fetchOperationsAndListingTypes");
    const townId = event.target.value;
    console.log("townId", townId);
    if (townId) {
      const response = await fetch(
        `/get_operations_and_listing_types?town_id=${townId}`
      );
      const data = await response.json();
      this.operationsTarget.innerHTML = data.operations_html;
      this.listingTypesTarget.innerHTML = data.listing_types_html;
    }
    this.submitForm();
  }
}
