import numpy as np
import matplotlib.pyplot as plt


# Question 1
def generate_data(data_size):
    # weight of each distribution is [0.2, 0.5, 0.3]
    u1 = np.array([0, 0])
    u2 = np.array([3, 0])
    u3 = np.array([0, 3])

    sigma = np.array([[1, 0], [0, 1]])

    x1, y1 = np.random.multivariate_normal(u1, sigma, int(data_size * 0.2)).T
    x2, y2 = np.random.multivariate_normal(u2, sigma, int(data_size * 0.5)).T
    x3, y3 = np.random.multivariate_normal(u3, sigma, int(data_size * 0.3)).T

    data = np.vstack((
        np.hstack((x1, x2, x3)),
        np.hstack((y1, y2, y3))
    )).T

    return data


def l2_distance(a, b):
    # compute the min distance between a and b with l2 distance.
    return np.sum(np.square(a - b))


def close_center(point, centers):
    # return the closest center index. The centers is givin as a list
    min_index = 0
    for i in range(len(centers)):
        if l2_distance(point, centers[i]) < l2_distance(point, centers[min_index]):
            min_index = i
    return min_index


def k_means_inital(data, k):
    # generate initial points k points for the clustering
    centers = [data[0]]

    for i in range(1, k):
        distance = np.zeros(data.shape[0])
        for points_ind in range(data.shape[0]):
            # compute the distance with the nearest center
            ind = close_center(data[points_ind], centers)
            distance[points_ind] = l2_distance(data[points_ind], centers[ind])
        distance = distance / np.sum(distance)
        # pick one index
        new_ind = np.random.choice(data.shape[0], 1, p=distance)[0]
        centers.append(data[new_ind])

    return centers


def k_means(data, k):
    # initialization for centers
    centers = k_means_inital(data, k)
    classes = np.zeros(data.shape[0], dtype='int8')

    losses = np.zeros(20)
    # iter 20 times:
    for t in range(20):

        # assign classes for each node
        for i in range(data.shape[0]):
            classes[i] = close_center(data[i], centers)
            losses[t] += l2_distance(data[i], centers[classes[i]])

        # renew the classes
        new_centers = np.zeros((k, 2))
        counts = np.zeros(k, dtype='int')
        for i in range(data.shape[0]):
            c = classes[i]
            counts[c] += 1
            new_centers[c] += data[i]

        new_centers = [new_centers[i] / counts[i] for i in range(k)]

        # early stop condition
        if l2_distance(np.asarray(centers), np.asarray(new_centers)) < 1e-4:
            losses[t:] = losses[t]
            break

        # update the centers
        centers = new_centers

    # the loss and classes is the final result
    plt.xlabel("Iteration")
    plt.ylabel("Loss")
    plt.title("Loss vs Iteration, K=%d" % k)
    plt.plot(np.arange(20), losses)
    plt.grid(True)
    plt.savefig(("k_means_loss_k=%d.png" % k))
    plt.show()

    # the clustering result
    centers = np.asarray(centers)
    plt.scatter(data[:, 0], data[:, 1], c=classes, edgecolors='none')
    plt.scatter(centers[:, 0], centers[:, 1], c='red', marker='x', s=50)
    plt.title("Clustering, K=%d" % k)
    plt.xlabel("x")
    plt.ylabel("y")
    plt.savefig(("k_means_cluster_k=%d.png" % k))
    plt.show()


# Question 2
def load_data():
    # load data for question 2
    data_train = np.genfromtxt('/Users/ptfairy/Desktop/COMS4721_hw4-data/ratings.csv', delimiter=',')
    data_test = np.genfromtxt('/Users/ptfairy/Desktop/COMS4721_hw4-data/ratings_test.csv', delimiter=',')

    with open("/Users/ptfairy/Desktop/COMS4721_hw4-data/movies.txt", 'r') as file:
        names = []
        for i in range(2000):
            line = file.readline()
            if line is '':
                break
            names.append(line[:-1])

    return data_train, data_test, names


def missing_matrix(data_train, data_test, d=10, sigma=0.25, iteration=100):
    # initialization
    user_num = int(np.max(data_train[:, 0]))
    movie_num = int(np.max(data_train[:, 1]))
    loss = np.zeros(iteration)

    # =========================================================================
    # generate the initial ui and vi. Increase the upper limit for convenience.
    # =========================================================================
    U = np.random.normal(0, 1, size=(user_num + 1, d))
    V = np.random.normal(0, 1, size=(movie_num + 1, d))

    UUT = np.array([np.dot(u.reshape(-1, 1), u.reshape(-1, 1).T) for u in U])
    VVT = np.array([np.dot(v.reshape(-1, 1), v.reshape(-1, 1).T) for v in V])

    # =========================================================================
    # generate the mapping between user and movie
    # =========================================================================
    user_mapping = [[] for _ in range(user_num + 1)]
    movie_mapping = [[] for _ in range(movie_num + 1)]

    for data in data_train:
        user_id = int(data[0])
        movie_id = int(data[1])
        rate = data[2]
        user_mapping[user_id].append([movie_id, rate])
        movie_mapping[movie_id].append([user_id, rate])

    for i in range(1, len(user_mapping)):
        if len(user_mapping[i]) == 0:
            continue
        temp = np.asarray(user_mapping[i])
        user_mapping[i] = temp[np.argsort(temp[:, 0])]

    for j in range(1, len(movie_mapping)):
        if len(movie_mapping[j]) == 0:
            continue
        temp = np.asarray(movie_mapping[j])
        movie_mapping[j] = temp[np.argsort(temp[:, 0])]
    print(user_mapping[1])
    # =========================================================================
    # main loop
    # =========================================================================
    for t in range(iteration):

        # =================================
        # update U
        # =================================
        for i in range(1, len(user_mapping)):
            # u_i = (lambda * sigma * Eye + Sum(v_j [dot] v_j.T))^-1 [dot] Sum(Mij * v_j)
            if len(user_mapping[i]) == 0:
                U[i] = np.zeros_like(U[i])
                continue

            movies = np.asarray(user_mapping[i][:, 0], dtype='int')
            ratings = np.asarray(user_mapping[i][:, 1])

            A = np.linalg.inv(sigma * np.eye(d) + np.sum(VVT[movies], axis=0))
            B = np.dot(ratings, V[movies])

            U[i] = np.dot(A, B)

        UUT = np.array([np.dot(u.reshape(-1, 1), u.reshape(-1, 1).T) for u in U])

        # =================================
        # update V
        # =================================
        for j in range(1, len(movie_mapping)):
            # v_j = (lambda * sigma * Eye + Sum(u_i [dot] u_i.T))^-1 [dot] Sum(M_ij * u_i)
            if len(movie_mapping[j]) == 0:
                V[j] = np.zeros_like(V[j])
                continue

            users = np.asarray(movie_mapping[j][:, 0], dtype='int')
            ratings = np.asarray(movie_mapping[j][:, 1])

            A = np.linalg.inv(sigma * np.eye(d) + np.sum(UUT[users], axis=0))
            B = np.dot(ratings, U[users])

            V[j] = np.dot(A, B)

        VVT = np.array([np.dot(v.reshape(-1, 1), v.reshape(-1, 1).T) for v in V])

        # =================================
        # calculate the loss function:
        # =================================
        for data in data_train:
            user_id = int(data[0])
            movie_id = int(data[1])
            rate = data[2]
            loss[t] -= np.square(rate - np.dot(U[user_id].T, V[movie_id]))
        loss[t] /= (2 * sigma)

        loss[t] -= np.sum(np.asarray([np.dot(ui.T, ui) for ui in U])) * 1 / 2
        loss[t] -= np.sum(np.asarray([np.dot(vi.T, vi) for vi in V])) * 1 / 2

        # print("Iteration t=%d, loss=%f" % (t, loss[t]))

    # =========================================================================
    # prediction
    # =========================================================================
    RMSE = 0
    for data in data_test:
        user_id = int(data[0])
        movie_id = int(data[1])
        rate = data[2]
        RMSE += np.square(rate - np.dot(U[user_id].T, V[movie_id]))
    RMSE = np.sqrt(RMSE / data_test.shape[0])

    return loss, RMSE, U, V


def plot_and_table(result_all, iteration=100):
    # order the result and return the best U and V
    losses = np.asarray([result[0] for result in result_all])
    index = np.argsort(losses[:, -1])[::-1]
    result_all = [result_all[i] for i in index]

    # plot the loss
    with open("result_table.txt", "w") as file:
        print("======Table for Loss vs RMSE======")
        file.write("======Table for Loss vs RMSE======\n")
        run_turn = 0
        for result in result_all:
            run_turn += 1
            print("=  Loss: %.2f" % result[0][-1], "|", "RMSE: %.2f  =" % result[1])
            file.write(("=  Loss: %.2f | RMSE: %.2f  =\n" % (result[0][-1], result[1])))
            plt.ticklabel_format(style='sci', axis='y', scilimits=(0, 0))
            plt.plot(np.arange(2, iteration + 1), result[0][1:], label='turn %d' % run_turn)
        print("==================================")
        file.write("==================================")

    plt.xlabel("Iteration $t$")
    plt.ylabel("Log Joint Likelihood $L$")
    plt.title("Loss and Iteration")

    legend_list = ['turn %d' % run_turn for run_turn in range(1, len(result_all) + 1)]
    plt.legend(legend_list, loc=4)

    plt.grid(True)
    plt.savefig("2_a.png")
    plt.show()

    return result_all[0]


def name_recommendation(names, V, num=10, targets="Star Wars"):
    # find the index of our targets (use list if there are duplicate name) :
    matching = [names.index(s) for s in names if targets in s]

    # get the distance of each nodes if there are matchings
    name_mapping = []
    for movie in matching:
        distances = np.asarray([l2_distance(V[movie], V[i]) for i in range(1, V.shape[0])])
        neighbor = np.argpartition(distances, num + 1)[1:num + 1]
        neighbor_names = [names[i] for i in neighbor]

        name_mapping.append([names[movie], neighbor_names])

    return name_mapping


def target_table(names, targets, V, num=10):
    # print the result of our target recommandation
    with open("result_recommendation.txt", "w") as file:
        for tar in targets:
            name_mapping = name_recommendation(names, V, num=num, targets=tar)

            for item in name_mapping:
                print("Movie: %s" % item[0])
                print("Recommendation: ", item[1])
                print()
                file.write("Movie: %s \n" % item[0])
                file.write(("Recommendation: " + str(item[1]) + "\n"))


if __name__ == '__main__':
    # Question 1.
    # data = generate_data(500)
    # for k in [1, 2, 3, 4, 5]:
    #     k_means(data, k)

    # Question 2
    data_train, data_test, names = load_data()
    loss, RMSE, U, V = missing_matrix(data_train, data_test, d=10, sigma=0.25, iteration=100)
    UV = np.dot(U, V.T)
    print(UV.shape[1])
    np.savetxt("foo.csv", UV, delimiter=",")

    # iteration = 100
    # result_all = []p
    # for turn in range(10):
    #     print("=======turn %d======" % turn)
    #     loss, RMSE, U, V = missing_matrix(data_train, data_test, iteration=iteration)
    #     result_all.append([loss, RMSE, U, V])
    #
    # # Question 2.a
    # best_result = plot_and_table(result_all, iteration=iteration)
    #
    # # Question 2.b
    # targets = ["Star Wars", "My Fair Lady", "GoodFellas"]
    # target_table(names=names, targets=targets, V=best_result[3])
