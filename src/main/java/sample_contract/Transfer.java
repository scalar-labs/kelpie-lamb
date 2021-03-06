package sample_contract;

import com.scalar.dl.ledger.asset.Asset;
import com.scalar.dl.ledger.contract.Contract;
import com.scalar.dl.ledger.database.Ledger;
import com.scalar.dl.ledger.exception.ContractContextException;
import java.util.Optional;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;

public class Transfer extends Contract {

  @Override
  public JsonObject invoke(Ledger ledger, JsonObject argument, Optional<JsonObject> properties) {
    JsonArray array = argument.getJsonArray("asset_ids");
    int amount = argument.getInt("amount");
    String fromId = array.getString(0);
    String toId = array.getString(1);
    if (fromId.equals(toId)) {
      throw new ContractContextException("transfer between the same ID isn't supported");
    }

    Asset from = ledger.get(fromId).get();
    Asset to = ledger.get(toId).get();
    JsonObject fromData = from.data();
    JsonObject toData = to.data();

    int fromBalance = fromData.getInt("balance");
    int toBalance = toData.getInt("balance");

    JsonObjectBuilder fromBuilder = Json.createObjectBuilder(fromData);
    fromBuilder.add("balance", fromBalance - amount);
    fromBuilder.add("order_id", argument.getString("order_id"));
    fromBuilder.add("paid_for", argument.getString("paid_for"));
    fromBuilder.add("paid_at", argument.getJsonNumber("paid_at"));

    JsonObjectBuilder toBuilder = Json.createObjectBuilder(toData);
    toBuilder.add("balance", toBalance + amount);
    toBuilder.add("order_id", argument.getString("order_id"));
    toBuilder.add("paid_for", argument.getString("paid_for"));
    toBuilder.add("paid_at", argument.getJsonNumber("paid_at"));

    ledger.put(from.id(), fromBuilder.build());
    ledger.put(to.id(), toBuilder.build());

    return null;
  }
}
