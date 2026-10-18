import { application } from "controllers/application";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
import Notification from "@stimulus-components/notification";

eagerLoadControllersFrom("controllers", application);
application.register("notification", Notification);
